#!/usr/bin/perl

print "===================================================\n";
print "           WELCOME TO COMPUTEMPG PROGRAM!          \n";
print "===================================================\n";
print "You will be prompted for gallons of gas and miles driven for this program. Please enter X when finished.\n\n";

my $gallonInput;
my $milesInput;
my $gallonSoFar = 0;
my $milesSoFar = 0;
my $debug = 1; # Change to 0 when not debugging

while(1) {

    # Getting user input
    print "Please enter numbers of gallons used:\n";
    chomp($gallonInput = <>);
    
    # If the user's input is invalid, prompt again until we get the expected input
    while(!checkNumericInput($gallonInput) && $gallonInput ne "X") {
        print "Invalid input, must be positive numbers.\nPlease enter the value again.\n";
        chomp($gallonInput = <>);
    }

    # Handling exit of the application. 
    if($gallonInput eq 'X') {
        my $mpg = $milesSoFar / $gallonSoFar if $gallonSoFar != 0;
        $mpg = substr($mpg, 0, 10); # truncate to 10 characters long so we don't have to deal with really long string
        # You cannnot have the gallons you used as 0 since you cannot divide by 0. So we have to print statement to take care of the odd case
        print "\nYour vehicle gets $mpg miles per gallon.\n" if $gallonSoFar != 0;
        print "\nYour vehicle has used up $gallonSoFar gallons. We cannot calculate your MPG.\n" if $gallonSoFar == 0;
        last;
    }

    # Getting user's input for miles
    print "Please enter number of miles driven on that many gallons:\n";
    chomp($milesInput = <>);
    
    # Reprompting continuously until the user inputs a valid number
    while(!checkNumericInput($milesInput)) {
        print "Invalid input, must be positive numbers. You cannot exit at this stage as well.\n";
        chomp($milesInput = <>);
    }

    # Add the new information into what we have so far so that we can calculate the 
    $gallonSoFar += $gallonInput;
    $milesSoFar += $milesInput;
}

# Subroutine to check whether the input is a positive number, decimal or not
sub checkNumericInput {
    $input = $_[0]; # getting input from parameter array
    print "You have entered: $input.\n" if $debug;
    
    # Matching regex, if it's numeric, return 1 for true, else return 0 for false
    if($input =~ /^[0-9]+(\.[0-9]+)?$/) {
        return 1;
    } else {
        return 0;
    }
}