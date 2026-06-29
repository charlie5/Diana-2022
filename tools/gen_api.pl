#!/usr/bin/env perl
# gen_api.pl — generate the builder/accessor API over Diana.Nodes from the spec.
#
#   perl tools/gen_api.pl builders  > harness/src/diana-builders.ads
#   perl tools/gen_api.pl accessors > harness/src/diana-accessors.ads
#
# Diana.Builders : one value constructor per CONCRETE node — an expression
#   function taking every attribute (own + inherited, all defaulted) and
#   returning the node value via a complete named aggregate.  Build bottom-up:
#   make the children first, then pass their cursors to the parent constructor.
#
# Diana.Accessors : per type, Is_<T> (a kind test) and As_<T> (a typed class-
#   wide view of the node at a cursor).  Read attributes as  As_<T> (C).Attr  —
#   the record components are public, so one view function per type avoids the
#   pervasive attribute-name collisions a per-attribute getter scheme would hit.
#
# Both packages are spec-only (all expression functions) and are generated; the
# attribute mapping mirrors tools/gen_nodes.pl.
use strict; use warnings;

my $mode = shift @ARGV // '';
die "usage: gen_api.pl builders|accessors [spec]\n"
    unless $mode eq 'builders' || $mode eq 'accessors';
my $file = shift @ARGV // 'spec/DIANA_2022.idl';
local $/; open my $fh, '<', $file or die "cannot open $file: $!";
my $t = <$fh>;
$t =~ s/--[^\n]*//g;
$t =~ s/\bStructure\b.*?\bIs\b//s;

my %skip = map { $_ => 1 } qw(
    Diana_Node
    Source_Position Comments Symbol_Rep Value Number_Rep
    Static_Value No_Value String_Value Boolean_Value Integer_Value Real_Value);

my %reserved = map { lc($_) => 1 } qw(
    abort abs abstract accept access aliased all and array at begin body case
    constant declare delay delta digits do else elsif end entry exception exit
    for function generic goto if in interface is limited loop mod new not null
    of or others out overriding package parallel pragma private procedure
    protected raise range record rem renames requeue return reverse select
    separate some subtype synchronized tagged task terminate then until type
    use when while with xor);
sub ada_id { my $n = shift; return $reserved{lc $n} ? $n.'_Item' : $n; }

my (@names, %seen, %is_class, %parent, %attrs);
sub note { my $n = shift; unless ($seen{$n}) { $seen{$n}=1; push @names, $n; } }

for my $stmt (split /;/, $t) {
    $stmt =~ s/^\s+|\s+$//g;
    next if $stmt eq '' || $stmt =~ /^End$/i || $stmt =~ /^Type\s+\w+$/;
    if ($stmt =~ /::=/) {
        my ($lhs, $rhs) = split /::=/, $stmt, 2;
        $lhs =~ s/\s+//g;
        $is_class{$lhs} = 1; note $lhs;
        for my $alt (split /\|/, $rhs) {
            $alt =~ s/\s+//g;
            next unless $alt =~ /^[A-Za-z]\w*$/;
            note $alt;
            next if $alt eq 'Void';
            $parent{$alt} = $lhs;
        }
    } elsif ($stmt =~ /=>/) {
        my ($lhs, $rhs) = split /=>/, $stmt, 2;
        $lhs =~ s/\s+//g;
        note $lhs;
        next if $skip{$lhs};
        while ($rhs =~ /(\w+)\s*:\s*(Seq\s+Of\s+\w+|\w+)/g) {
            push @{$attrs{$lhs}}, [$1, $2];
        }
    }
}

# Ada parameter type + default for an IDL attribute type.
sub map_param {
    my $ty = shift;
    return ('Node_List', 'Node_Lists.Empty_Vector')        if $ty =~ /^Seq\s+Of\s+/;
    return ('Diana.Source_Position', 'No_Position')         if $ty eq 'Source_Position';
    return ('Diana.Comments', 'SU.Null_Unbounded_String')   if $ty eq 'Comments';
    return ('Diana.Symbol_Rep', 'SU.Null_Unbounded_String') if $ty eq 'Symbol_Rep';
    return ('Diana.Number_Rep', 'SU.Null_Unbounded_String') if $ty eq 'Number_Rep';
    return ('Diana.Static_Value', '(Kind => No_Value)')     if $ty eq 'Value';
    return ('Boolean', 'False')                             if $ty eq 'Boolean';
    return ('Integer', '0')                                 if $ty eq 'Integer';
    return ('Diana.Symbol_Rep', 'SU.Null_Unbounded_String') if $ty eq 'String';
    return ('Long_Long_Float', '0.0')                       if $ty eq 'Rational';
    return ('Cursor', 'No_Element');
}

# Full attribute list (root-down) for a concrete node: Node's universal pair,
# then every ancestor class's hoisted attributes, then the node's own.
sub full_attrs {
    my $n = shift;
    my @chain; my $cur = $n;
    while (defined $cur && !$skip{$cur}) {
        unshift @chain, $cur;
        my $p = $parent{$cur};
        last if !defined $p || $p eq 'Diana_Node';
        $cur = $p;
    }
    my @out = (['Source_Position','Source_Position'], ['Comments','Comments']);
    push @out, @{$attrs{$_} // []} for @chain;
    return @out;
}

# ---------------------------------------------------------------------------
if ($mode eq 'accessors') {
    my @ts = grep { !$skip{$_} } @names;
    print <<"HEAD";
--  Diana.Accessors — typed reads over the node tree.
--
--  GENERATED from spec/DIANA_2022.idl by tools/gen_api.pl.  DO NOT EDIT.
--
--  For each IDL type T:  Is_T (C) tests the node at cursor C, and As_T (C) is a
--  typed class-wide view of it (read attributes as  As_T (C).Attribute, since
--  the Diana.Nodes record components are public).  As_T raises Constraint_Error
--  if the node is not a T — guard with Is_T.

pragma Style_Checks (Off);

with Diana.Nodes;

package Diana.Accessors is

HEAD
    for my $n (@ts) {
        my $id = ada_id($n);
        printf "   function Is_%s (C : Cursor) return Boolean\n".
               "     is (Trees.Element (C) in Diana.Nodes.%s'Class);\n", $id, $id;
        printf "   function As_%s (C : Cursor) return Diana.Nodes.%s'Class\n".
               "     is (Diana.Nodes.%s'Class (Trees.Element (C)));\n\n", $id, $id, $id;
    }
    print "end Diana.Accessors;\n";
    print STDERR "gen_api accessors: ".scalar(@ts)." types\n";
    exit 0;
}

# ---------------------------------------------------------------------------
# builders
my @concrete = grep { !$skip{$_} && !$is_class{$_} } @names;
print <<"HEAD";
--  Diana.Builders — value constructors for every concrete node.
--
--  GENERATED from spec/DIANA_2022.idl by tools/gen_api.pl.  DO NOT EDIT.
--
--  Each function builds one node VALUE from its attributes (own + inherited,
--  all defaulted); append it to the tree to get a cursor (e.g. via
--  Diana.Library.Add_Child).  Build bottom-up: construct child nodes first,
--  then pass their cursors into the enclosing node's constructor.

pragma Style_Checks (Off);

with Diana.Nodes;

package Diana.Builders is

HEAD

for my $n (@concrete) {
    my $id = ada_id($n);
    my @fa = full_attrs($n);
    # widest param name for alignment
    my $w = 0; for my $a (@fa) { my $c = ada_id($a->[0]); $w = length $c if length $c > $w; }

    my @plines;
    for my $a (@fa) {
        my ($pt, $def) = map_param($a->[1]);
        push @plines, sprintf "%-*s : %s := %s", $w, ada_id($a->[0]), $pt, $def;
    }
    my @agg = map { my $c = ada_id($_->[0]); sprintf "%s => %s", $c, $c } @fa;

    print "   function $id\n";
    print "     (", join(";\n      ", @plines), ")\n";
    print "      return Diana.Nodes.$id\n";
    print "   is (", join(",\n       ", @agg), ");\n\n";
}
print "end Diana.Builders;\n";
print STDERR "gen_api builders: ".scalar(@concrete)." constructors\n";
