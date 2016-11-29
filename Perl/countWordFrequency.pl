#!/usr/bin/perl

# Anh Vu Nguyen
# Assignment 3, Q4

open(INF, "<", @ARGV[0]) or die "Couldn't find the input file: @ARGV[0]. Please try again with the following format: ./countWordFrequence.pl <FILE_PATH>. \n";
print "Input File: " . $ARGV[0] . "\n";
print "WARNING: This script generates a file ($ARGV[0]_wordCount.txt) that keep track of count of words in $ARGV[0].\n";

my $outputFileName = $ARGV[0] . "_wordCount.txt";

open($OUT, ">", $outputFileName) or die "Having trouble writing frequence to ouput count.";

# The hash that will keep frequency
%hashCount;

# Adapted code to slurp the whole file
local $/;
$inBuffer = <INF>;
while(1)
{
	# print "Original inBuffer: " . $inBuffer . "\n";
	my $word = "";
	if( $inBuffer =~ m/^(\s*)([a-z|A-Z|\']+)(\s+)?/ ) {
		$word = $2;
		$inBuffer = $';
	} elsif( $inBuffer =~ m/(.)/ ) {
		# print "\$1: " . $1 . "\n";
		$inBuffer = $';
	}	
	# print "Parsed word: " . $word . "\n";
	# print "New inBuffer: " . $inBuffer . "\n";
	
	if($word && $hashCount{"$word"}) {
		$currCount = $hashCount{"$word"};
		$hashCount{"$word"} = $currCount + 1;
	} elsif($word) {
		$hashCount{"$word"} = 1;
	}

	if($inBuffer =~ m/^([^a-z|^A-Z|^\'])?(\s*)$/) {
		last;
	}
}

print "\nThe frequence of words in the provided file: \n";
print $OUT "The frequencies of words in $ARGV[0]: \n";
while( my( $key, $value ) = each %hashCount ){  
        print "$key: $value\n"; 
	print $OUT "$key: $value\n";
}
