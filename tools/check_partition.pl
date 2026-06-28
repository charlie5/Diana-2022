#!/usr/bin/env perl
# check_partition.pl — verify the DIANA_2022 single-parent invariant.
#
# Every node/class in spec/DIANA_2022.idl must be a member (an alternative on
# the right-hand side of a "::=" production) of AT MOST ONE class — except the
# universal node "void", which is the one sanctioned exception (Rev 4 rule).
#
# Reports each name that is a member of more than one class, with its parents.
# Exits 0 if the spec is single-parent (only void multiply-membered), else 1.
#
# Usage:  perl tools/check_partition.pl [spec/DIANA_2022.idl]
use strict; use warnings;
my $file = shift @ARGV // 'spec/DIANA_2022.idl';
local $/; open my $fh, '<', $file or die "cannot open $file: $!";
my $t = <$fh>;
$t =~ s/--[^\n]*//g;          # strip comments
$t =~ s/\s+/ /g;              # collapse whitespace
my %parents;                  # member -> { parent => 1 }
for my $stmt (split /;/, $t) {
    next unless $stmt =~ /::=/;
    my ($lhs, $rhs) = split /::=/, $stmt, 2;
    my ($parent) = $lhs =~ /(\S+)\s*$/;       # last token before ::=
    next unless $parent;
    for my $m (split /\|/, $rhs) {
        $m =~ s/^\s+|\s+$//g;
        next unless $m =~ /^[A-Za-z]\w*$/;
        $parents{$m}{$parent} = 1;
    }
}
my $bad = 0;
for my $m (sort keys %parents) {
    next if lc $m eq 'void';                  # the sanctioned exception
    my @p = sort keys %{$parents{$m}};
    if (@p > 1) { $bad++; printf "  %-26s in: %s\n", $m, join(', ', @p); }
}
if ($bad) { print "\n$bad name(s) in more than one class.\n"; exit 1; }
print "OK: single-parent (only 'void' is multiply-membered, by design).\n";
exit 0;
