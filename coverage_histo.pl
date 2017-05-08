#!/usr/bin/env perl

use Getopt::Long;
use Data::Dumper;
$Data::Dumper::Indent = 1;

use 5.010;
use strict;
use warnings;

GetOptions(
    'window-size-file|w=s', \my $window_size_file,
    'step-size|s=i',        \my $step_size,
) or help();

my $input = shift @ARGV;

unless ($window_size_file and -f $window_size_file) {
    say "Not found : $window_size_file" if $window_size_file;
    help();
}

unless ($step_size and $step_size > 0) {
    say "step-size should be bigger than zero" if $step_size;
    help();
}

unless ($input and -f $input) {
    say "Not found Input file: $input" if $input;
    help();
}

my $window_sizes = read_window_sizes($window_size_file);

exit main(
    window_sizes => $window_sizes,
    step_size => $step_size,
    input_file => $input,
);

sub main {
    my (%args) = @_;

    my %t;

    open my $fh, '<', $args{input_file} or die "Cannot open $args{input_file}: $!";
    while (my $aline = <$fh>) {
        my ($id, $loc, undef, $cov) = split /\s+/, $aline;
        my $step = int($loc / $args{step_size});
        $t{$id}{$step}{total} += $cov;
        $t{$id}{$step}{num}++;
    }
    close $fh;

    while (my ($id, $idh) = each %t) {
        while (my ($step, $s) = each %$idh) {
            #say Dumper $s;
            $s->{avg} = $s->{total} / $s->{num};
        }
    }

    #say Dumper \%t;

    my $STEP = $args{step_size};
    for my $id (sort keys %t) {
        my $id_hashref = $t{$id};

        for (my $i=0; $i*$STEP <= $args{window_sizes}{$id}; ++$i) {

            my $end_step = ($i+1) * $STEP - 1;
            $end_step = $end_step <= $args{window_sizes}{$id} ? $end_step
                                                              : $args{window_sizes}{$id};
            my $avg_cov = $id_hashref->{$i} ? $id_hashref->{$i}->{avg}
                                            : 0;

            printf "%s\t%d\t%d\t%.1f\n",
                $id,        # id
                $i * $STEP, # start step
                $end_step,  # end step
                $avg_cov,   # avg coverage
            ;
        }
    }
}

sub read_window_sizes {
    my ($file) = @_;
    my %window_sizes;

    open my $fh, '<', $file or die "Cannot open $file: $!";
    while (my $aline = <$fh>) {
        chomp $aline;
        my ($id, $max) = split /\s+/, $aline;
        $window_sizes{$id} = $max;
    }
    close $fh;

    return \%window_sizes;
}

sub help {
    say "Usage: $0 --window-size-file=<size filename> --step-size=<step size> <input file>";
    exit 1;
}
