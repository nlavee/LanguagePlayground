#!/usr/bin/perl

print "===================================================\n";
print "       WELCOME TO PALINDROME CHECK B PROGRAM!      \n";
print "===================================================\n";
print "Please enter a string to check whether it's a palindrome\n\n";
my $input = <>;
chomp($input);
print "You have entered '$input'.\n";

my $debug = 0; # Toogle to 1 when debugging

while(1) {

    # We know the string is a palindrome when it has one character or when it's an empty string
    if(!$input || $input =~ /^.$/) {
        print "This is a palindrome if I ignore whitespace and punctuation and case.\n";
        last;
    }

    # Variable for first and last char to compare
    my $firstChar;
    my $lastChar;

    # If the first character is those that needed to be disregarded (space, period, ; and comma), skip forward
    while($input =~ /^[\s\.;,]/) {
        $input = $'; # remove the first character from string we're assessing
    }
    # Now we can get the first letter in the string to assess
    if($input =~ /^(.)/) {
        $firstChar = $1;
        $input = $';
    }
    print $firstChar . "\n" if $debug;

    # If the last character is those that needed to be disregarded, skip forward
    while($input =~ /[\s\.;,]$/) {
        $input = $`; # remove the last character from string we're assessing
    }
    # Now we can get the last letter in the string to assess
    if($input =~ /(.)$/) {
        $lastChar = $1;
        $input = $`;
    }
    print $lastChar . "\n" if $debug;

    # Print whatever is left in input when debugging
    print $input . "\n" if $debug;

    # If at any point, the last and first characters are different (ignore case), we don't have a palindrome. 
    # Except for when lastChar is empty.
    if($firstChar !~ /$lastChar/i && $lastChar ne "") {
        print "This is not a palindrome.\n";
        last;
    }
}