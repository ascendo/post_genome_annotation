#!/usr/bin/env perl


#Usage = ./scriptname.pl [filename]
#Input = file with sequences in FASTA format.
#Output = tab delimited output with SequenceID and %GC
#NOTE: gc content is calculated as G+C/(A+T+C+G).  Other letters, such as ambigous bases are ignored.

use strict;
use Bio::SeqIO;

#import a file contains sequences in FASTA format.
my $filename = shift(@ARGV) or die "COULD NOT OPEN THE FASTA FILE\nUSAGE: gc_percent1.0.pl filename\n";
my $in = Bio::SeqIO-> new(-format => 'fasta' ,
                           -file => $filename);

#get the sequence data
while( my $seq = $in->next_seq ) {
    #zero the counts
    my $acount = 0;
    my $tcount = 0;
    my $gcount = 0;
    my $ccount = 0;
    my $id = $seq->display_id;
    my $length = $seq->length;
    my $dna = $seq->seq;
    my @bases = split // , $dna;
#count the bases
  foreach my $bases(@bases) {
            if ($bases =~ m/a/i) {
                $acount++;
            }
            if ($bases =~ m/t/i) {
                $tcount++;
            }
            if ($bases =~ m/g/i) {
                $gcount++;
            }
            if ($bases =~ m/c/i) {
                $ccount++;
            }

  }
#calculate gc percentage
  my $gc = $gcount + $ccount;
  my $all = $acount + $tcount + $gcount + $ccount;
  my $percentgc = (($gc / $all) * 100);
  print "$id\t";
  printf "%.1f\n" , $percentgc;
}
