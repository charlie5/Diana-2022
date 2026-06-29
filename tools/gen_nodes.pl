#!/usr/bin/env perl
# gen_nodes.pl — generate the Ada package Diana.Nodes from spec/DIANA_2022.idl.
#
# The IDL is a single-parent class lattice; this emits it as an Ada tagged-type
# hierarchy (the realisation decided with Shark8 — see harness/src/diana.ads):
#
#   * Each IDL class ("X ::= ...")  -> an ABSTRACT tagged type.
#   * Each IDL node  ("X => ...")   -> a CONCRETE (leaf) tagged type.
#   * A type's single IDL parent class is its Ada parent; orphans and the
#     universal "Void" derive directly from the root Diana.Node.
#   * Hoisted class attributes ("Class => ...") become components on the
#     abstract type, inherited by every leaf (single inheritance == the
#     single-parent partition).
#
# Attribute mapping (uniform and type-driven, so no node ever depends on
# another node's Ada declaration — only the parent link orders the output):
#
#   private/scalar  Source_Position|Comments|Symbol_Rep|Number_Rep -> that type
#                   Value -> Static_Value;  Boolean|Integer -> same;
#                   String -> Symbol_Rep;   Rational -> Long_Long_Float
#   Seq Of T        -> Node_List          (a vector of element cursors)
#   any node/class  -> Cursor             (the in-memory form of a cross-link
#                                          or a structural child edge)
#
# The six private types and the Static_Value value-model (already realised in
# diana.ads) and the root Diana_Node are NOT re-emitted.
#
# Usage:  perl tools/gen_nodes.pl [spec/DIANA_2022.idl] > harness/src/diana-nodes.ads
use strict; use warnings;

my $file = shift @ARGV // 'spec/DIANA_2022.idl';
local $/; open my $fh, '<', $file or die "cannot open $file: $!";
my $t = <$fh>;

$t =~ s/--[^\n]*//g;                 # strip comments
$t =~ s/\bStructure\b.*?\bIs\b//s;   # drop the "Structure ... Is" header

# Names realised elsewhere (diana.ads) — parsed for structure but not emitted.
my %skip = map { $_ => 1 } qw(
    Diana_Node
    Source_Position Comments Symbol_Rep Value Number_Rep
    Static_Value No_Value String_Value Boolean_Value Integer_Value Real_Value);

# Ada 2022 reserved words — an emitted identifier colliding with one gets "_Item".
my %reserved = map { lc($_) => 1 } qw(
    abort abs abstract accept access aliased all and array at begin body case
    constant declare delay delta digits do else elsif end entry exception exit
    for function generic goto if in interface is limited loop mod new not null
    of or others out overriding package parallel pragma private procedure
    protected raise range record rem renames requeue return reverse select
    separate some subtype synchronized tagged task terminate then type until
    use when while with xor);
sub ada_id { my $n = shift; return $reserved{lc $n} ? $n.'_Item' : $n; }

my (@names, %seen, %is_class, %parent, %attrs);
sub note { my $n = shift; unless ($seen{$n}) { $seen{$n}=1; push @names, $n; } }

for my $stmt (split /;/, $t) {
    $stmt =~ s/^\s+|\s+$//g;
    next if $stmt eq '' || $stmt =~ /^End$/i || $stmt =~ /^Type\s+\w+$/;

    if ($stmt =~ /::=/) {                                   # class production
        my ($lhs, $rhs) = split /::=/, $stmt, 2;
        $lhs =~ s/\s+//g;
        $is_class{$lhs} = 1; note $lhs;
        for my $alt (split /\|/, $rhs) {
            $alt =~ s/\s+//g;
            next unless $alt =~ /^[A-Za-z]\w*$/;
            note $alt;
            next if $alt eq 'Void';                         # Void -> root (the exception)
            $parent{$alt} = $lhs;                           # single-parent (verified by checker)
        }
    } elsif ($stmt =~ /=>/) {                               # node / attribute production
        my ($lhs, $rhs) = split /=>/, $stmt, 2;
        $lhs =~ s/\s+//g;
        note $lhs;
        next if $skip{$lhs};
        while ($rhs =~ /(\w+)\s*:\s*(Seq\s+Of\s+\w+|\w+)/g) {
            push @{$attrs{$lhs}}, [$1, $2];
        }
    }
}

# Map an IDL attribute type to (Ada type, optional default).
sub map_type {
    my $ty = shift;
    #  Diana-defined types are qualified ("Diana.") so a component may share its
    #  type's name (e.g. Static_Value : Diana.Static_Value) without the record
    #  shadowing the type-mark.
    if ($ty =~ /^Seq\s+Of\s+/)         { return ('Node_List', ''); }
    return ('Diana.Source_Position', ' := No_Position')    if $ty eq 'Source_Position';
    return ('Diana.Comments', '')                          if $ty eq 'Comments';
    return ('Diana.Symbol_Rep', '')                        if $ty eq 'Symbol_Rep';
    return ('Diana.Number_Rep', '')                        if $ty eq 'Number_Rep';
    return ('Diana.Static_Value', '')                      if $ty eq 'Value';
    return ('Boolean', ' := False')                        if $ty eq 'Boolean';
    return ('Integer', ' := 0')                            if $ty eq 'Integer';
    return ('Diana.Symbol_Rep', '')                        if $ty eq 'String';
    return ('Long_Long_Float', ' := 0.0')                  if $ty eq 'Rational';
    return ('Cursor', ' := No_Element');                   # any node/class reference
}

# Emit in an order where every type's parent precedes it (parent links are the
# only ordering constraint; all attributes are cursors/scalars/sequences).
my %emitted = (Node => 1, Diana_Node => 1);
my @queue = grep { !$skip{$_} } @names;

my $body = '';
my $n_abstract = 0; my $n_concrete = 0;

while (@queue) {
    my @next; my $progress = 0;
    for my $n (@queue) {
        my $p = $parent{$n} // 'Node';
        $p = 'Node' if $p eq 'Diana_Node';
        unless ($emitted{$p}) { push @next, $n; next; }

        my $kind = $is_class{$n} ? 'abstract ' : '';
        $is_class{$n} ? $n_abstract++ : $n_concrete++;
        my $pa = ($p eq 'Node') ? 'Node' : ada_id($p);
        my @flds = @{ $attrs{$n} // [] };

        my $tag = $is_class{$n} ? 'class' : 'node ';
        if (!@flds) {
            $body .= sprintf "   type %s is %snew %s with null record;\n",
                             ada_id($n), $kind, $pa;
        } else {
            # widest component name, for colon alignment
            my $w = 0;
            for my $f (@flds) { my $c = ada_id($f->[0]); $w = length $c if length $c > $w; }
            $body .= sprintf "   type %s is %snew %s with record\n", ada_id($n), $kind, $pa;
            for my $f (@flds) {
                my ($at, $def) = map_type($f->[1]);
                $body .= sprintf "      %-*s : %s%s;\n", $w, ada_id($f->[0]), $at, $def;
            }
            $body .= "   end record;\n";
        }
        $emitted{$n} = 1; $progress = 1;
    }
    die "cycle / unresolved parent among: @next\n" unless $progress;
    @queue = @next;
}

my $total = $n_abstract + $n_concrete;
print <<"HEAD";
--  Diana.Nodes — the DIANA_2022 node set.
--
--  GENERATED from spec/DIANA_2022.idl by tools/gen_nodes.pl.  DO NOT EDIT BY
--  HAND; re-run the generator after changing the spec.
--
--  $total tagged types ($n_abstract abstract classes, $n_concrete concrete nodes).  Every IDL
--  class is an abstract type and every IDL node a concrete leaf, single-parent
--  per the spec; node/class references are Cursors and "Seq Of" is a Node_List.
--  See tools/gen_nodes.pl for the full mapping.

pragma Style_Checks (Off);

package Diana.Nodes is

HEAD
print $body;
print "\nend Diana.Nodes;\n";

print STDERR "gen_nodes: $total types ($n_abstract abstract, $n_concrete concrete)\n";
