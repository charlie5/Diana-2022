#!/usr/bin/env perl
# check_resolve.pl — verify DIANA_2022 referential completeness.
#
# Every name used in spec/DIANA_2022.idl — as an alternative of a "::=" class,
# or as the type of a "=>" attribute — must be DEFINED somewhere (by a "::=" or
# "=>" production), or be one of the basic IDL types / the implementation-defined
# private types / the universal node "void".
#
# Reports every referenced-but-undefined name. Exits 0 if all references
# resolve, else 1.
#
# Usage:  perl tools/check_resolve.pl [spec/DIANA_2022.idl]
use strict; use warnings;
my $file = shift @ARGV // 'spec/DIANA_2022.idl';
local $/; open my $fh, '<', $file or die "cannot open $file: $!";
my $t = <$fh>;
$t =~ s/--[^\n]*//g;                                  # strip comments
my (%def, %ref);
while ($t =~ /\b([A-Za-z]\w*)\s*(?:::=|=>)/g) { $def{$1} = 1; }   # all definitions
for my $s (split /;/, $t) {
    if ($s =~ /::=/) {                                 # class alternatives
        my (undef, $r) = split /::=/, $s, 2;
        for my $m (split /\|/, $r) { $m =~ s/\s+//g; $ref{$m} = 1 if $m =~ /^[A-Za-z]\w*$/; }
    }
    if ($s =~ /=>/) {                                  # attribute types
        my (undef, $r) = split /=>/, $s, 2;
        while ($r =~ /:\s*(?:Seq\s+Of\s+)?([A-Za-z]\w*)/g) { $ref{$1} = 1; }
    }
}
# Basic IDL types, the six private types, and the empty node:
my %known = map { $_ => 1 } qw(
    Boolean Integer String Rational Seq Of Void
    Source_Position Comments Symbol_Rep Value Number_Rep);
my @missing = grep { !$def{$_} && !$known{$_} } sort keys %ref;
if (@missing) {
    print "UNDEFINED (".scalar(@missing)."):\n", map { "  $_\n" } @missing;
    exit 1;
}
print "OK: all references resolve.\n";
exit 0;
