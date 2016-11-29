#!/usr/bin/perl

print "===================================================\n";
print "       WELCOME TO PALINDROME CHECK A PROGRAM!      \n";
print "===================================================\n";
print "Please enter a string to check whether it's a palindrome\n\n";
my $input = <>;
chomp($input);
print "You have entered '$input'.\n";

my $debug = 0; # Toogle to 1 when debugging

while(1) {

    # We know the string is a palindrome when it has one character or when it's an empty string
    if(!$input || $input =~ /^.$/) {
        print "This is a palindrome.\n";
        last;
    }

    # Variable for first and last char to compare
    my $firstChar;
    my $lastChar;

    # Getting the first character of the string
    if($input =~ /^(.)/) {
        $firstChar = $1;
        $input = $'; # remove the first character from string we're assessing
    }
    print $firstChar . "\n" if $debug;

    # Getting the last character of the string
    if($input =~ /(.)$/) {
        $lastChar = $1;
        $input = $`; # remove the last character from string we're assessing
    }
    print $lastChar . "\n" if $debug;

    # Print whatever is left in input when debugging
    print $input . "\n" if $debug;

    # If at any point, the last and first characters are different, we don't have a palindrome
    if($firstChar ne $lastChar) {
        print "Not a palindrome.\n";
        last;
    }
}