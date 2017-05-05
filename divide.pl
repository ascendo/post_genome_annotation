use strict;
use warnings;
use Text::CSV_XS;
use Data::Printer;

my $csv = Text::CSV_XS->new({ binary => 1, sep_char => "\t" });
open my $fh, "<", $ARGV[0] or die $!;

# 1. 키맵 생성

my $count = 0;
while(my $row = $csv->getline($fh)) {
    if ($row->[2] && $row->[2] eq 'exon') {
        my ($parent_str)  = $row->[8] =~ /Parent=([^;]+);/;
        for my $parent_col (split ",", $parent_str) {
            $row->[8] =~ s/Parent=([^;]+);/Parent=$parent_col;/;
            print join("\t", @{ $row })."\n";
        }
        next;
    }
    print join("\t", @{ $row })."\n";
}
