#!/usr/bin/perl

# NOTE FOR TESTING:
# The following source code will test and return a successful parse: 
#           testParser.txt
#           testParser.2.txt
#           testParser.3.txt
#           testParser.4.txt
#           testParser.9.txt (this file aims to run every single line of the source code)
# The following source code will test and return a parse with error:
#           testParser.5.txt (Error reason: have extra stuff at the end)
#           testParser.6.txt (Error reason: wrong format for Progname)
#           testParser.7.txt (Error reason: didn't close compound statement)
#           testParser.8.txt (Error reason: using more than one multiplying operator)
#
# To run the test files, please run: ./parser.pl <NAME_OF_FILE_TO_RUN>
# Note: white space at the end doesn't count as having extra stuff at the end

$debug = 0; # Toogle to 0 if not debugging, toggle to 1 to see the full messages

# open file for source code
open (INF, "<", $ARGV[0]) or die "couldn't open sourcecode\n";

# these lines of code slurp the whole file into one scalar $in_buffer
{
    local $/;
    $in_buffer = <INF>;
}

# use the following lines in your program if you wish to add a $ to
# the end of the input program
chomp($in_buffer);
$in_buffer .= "\$";

# Create a hashset that contains all the terminals so we can check for terminals fater
my %terminals = (
    "end" => "end",
    "begin" => "begin",
    "program" => "program",
    ";" => ";",
    ":=" => ":=",
    "read" => "read",
    "(" => "(",
    "," => ",",
    ")" => ")",
    "write" => "write",
    "if" => "if",
    "then" => "then",
    "else" => "else", 
    "while" => "while",
    "do" => "do",
    "+" => "+",
    "-" => "-",
    "*" => "*",
    "/" => "/",
    "=" => "=",
    "<>" => "<>",
    "<" => "<",
    "<=" => "<=",
    ">=" => ">=",
    ">" => ">"
);

# MAIN PROGRAM, just call lex and program subroutines
lex();
program();

# Result of parsing
print "Successfully parsed input. Congratulations!\n\n" if $in_buffer =~ /^\$$/;
print "There's extra things at the end of the source code. Please check.\n\n" if $in_buffer !~ /^\$$/;


# =====================================================
# sub section for the subroutines that we'll call
# =====================================================

# Method for lex, which takes care of updating the next_token and return TERMINALS, VARIABLE, CONSTANT, PROGNAM
sub lex {
    # Getting next token and shrink buffer
    if($in_buffer =~ /^(\s+)$/) {
        print("\n-----MATCHES EMPTY SPACE ONLY------\n") if $debug;
        return;
    }
    elsif($in_buffer =~ /^((\s*)(program|begin|;|end|:=|read|\(|,|\)|write|if|then|else|while|do|\+|\-|\*|\/|=|<>|<=|>=|<|>)(.+))(\s*)/s) {
        print("\n-----MATCH FIRST CASE-----\n") if $debug;
        $next_token = $3;
        $in_buffer = $4 . $5 . $';
    } elsif($in_buffer =~ /^(\s*)([a-zA-z0-9]+?)(\s*)(program|begin|;|end|:=|read|\(|,|\)|write|if|then|else|while|do|\+|\-|\*|\/|=|<>|<=|>=|<|>)(.+)/s) { # case when we're at the last word
        print("\n-----MATCH SECOND CASE-----\n") if $debug;
        $next_token = $2;
        $in_buffer = $4 . $5 . $6 . $';
    } elsif($in_buffer =~ /^(\s*)(.+?)(\s*)(\$)$/) { # case when we've run out of word
        print("\n------MATCH THIRD CASE-----\n") if $debug;
        $next_token = $2;
        $in_buffer = $4;
    } elsif($in_buffer =~ /\s*\$/) {
        print("\n------MATCH FOURTH CASE-----\n") if $debug;
        return;
    } else { # if any other case, die
        print "Doesn't match anything.\n";
        die;
    }

    print $in_buffer ."\n" if $debug;
    print ">" . $next_token ."<\n" if $debug;
    
    # Matches terminals in hashes
    if($terminals{$next_token}) {
        print "MATCHES TERMINALS.\n------------------\n" if $debug;
        return $next_token;
    }
    # Matches progname
    if($next_token =~ /^[A-Z]([a-z0-9]*)$/) {
        print "MATCHES PROGNAME.\n------------------\n" if $debug;
        $next_token = "PROGNAME";
        return "PROGNAME";
    }
    # Matches variable
    if($next_token =~ /[a-zA-Z]([a-zA-Z0-9]*)/) {
        print "MATCHES VARIABLE.\n------------------\n" if $debug;
        $next_token = "VARIABLE";
        return "VARIABLE";
    }
    # Matches constant
    if($next_token =~ /[0-9]([0-9]*)/) {
        print "MATCHES CONSTANT.\n------------------\n" if $debug;
        $next_token = "CONSTANT";
        return "CONSTANT";
    }
    return $next_token;
}

sub program {
    print("........STARTING PROGRAM.......\n") if $debug;
    if($next_token eq "program") {
        lex();
        print $next_token . "\n" if $debug;
        if($next_token eq "PROGNAME") {
            lex();
            compound_stmt();
        } else {
            error($next_token, "PROGNAME");
        }
    } else {
        error($next_token, "program");
    }
    print ("........CLOSING PROGRAM.......\n") if $debug;
}

sub compound_stmt {
    print("......STARTING COMPOUND STATEMENT......\n") if $debug;
    if($next_token eq "begin") {
        lex();
        stmt();
        
        # Check to see whether we have more one statement
        while($next_token eq ";") {
            lex();
            stmt();
        }

        # Check for the end of the compound to be "end"
        if($next_token ne "end") {
            error($next_token, "end");
        } else {
            lex(); # NOTE: Actually, at this stage, it's safe to assume that if source code doesn't match end, it's wrong'
            return;
        }
    } else {
        error($next_token, "begin");
    }
    print(".........ENDING COMPOUND STATEMENT......\n") if $debug;
}

sub stmt {
    print("........STARTING STATEMENT......\n") if $debug;
    if(is_structured_stmt()) {
        structured_stmt();
    } else {
        simple_stmt();
    }
    print(".......CLOSING STATEMENT......\n") if $debug;
}

# Method to check to see whether what we have can be a simple statement
sub is_structured_stmt {
    if($next_token eq "begin" || $next_token eq "if" || $next_token eq "while") {
        print "MATCHES STRUCTURED STATEMENT.\n" if $debug;
        return 1;
    } else {
        print "MATCHES SIMPLE STATEMENT.\n" if $debug;
        return 0;
    }
}

sub simple_stmt {
    print("...........STARTING SIMPLE STATEMENT........\n") if $debug;
    if(is_write_stmt()) {
        write_stmt();
    } elsif(is_read_stmt()) {
        read_stmt();
    } else {
        assignment_stmt();
    } 
    print("..........CLOSING SIMPLE STATEMENT...........\n") if $debug;
}

sub is_write_stmt {
    if($next_token eq "write") {
        return 1;
    } else {
        return 0;
    }
}

sub is_read_stmt {
    if($next_token eq "read") {
        return 1;
    } else {
        return 0;
    }

}

sub assignment_stmt {
    print("...........STARTING ASSIGNMENT STATEMENT...........\n") if $debug;
    if($next_token eq "VARIABLE") {
        lex();
        if($next_token eq ":=") {
            lex();
            expression();
        } else {
            error($next_token, ":=");
        }  
    } else {
        error($next_token, "VARIABLE");
    }
    print("...........CLOSING ASSIGNMENT STATEMENT..........\n") if $debug;
}

sub read_stmt {
    print("...........STARTING READ STATEMENT.........\n") if $debug;
    if($next_token eq "read") {
        lex();
        if($next_token eq "(") {
            $next_token = lex();
            if($next_token eq "VARIABLE") {
                lex();
                while($next_token eq ",") {
                    $next_token = lex();
                    if($next_token ne "VARIABLE") {
                        error($next_token, "VARIABLE");
                    }
                    $next_token = lex();
                }

                if($next_token eq ")") {
                    lex();
                } else {
                    error($next_token, ") in read stmt");
                }
            } else {
                error($next_token, "VARIABLE");
            }
        } else {
            error($next_token, "(")
        }
    } else {
        error($next_token, "read");
    }
    print("...........CLOSING READ STATEMENT........\n") if $debug;
}

sub write_stmt {
    print("...........STARTING WRITE STATEMENT........\n") if $debug;
    if($next_token eq "write") {
        lex();
        if($next_token eq "(") {
            lex();
            expression();

            while($next_token eq ",") {
                lex();
                expression();
            }
        } else {
            error($next_token, "(");
        }

        if($next_token eq ")") {
            lex();
        } else {
            error($next_token, ") in write_stmt");
        }
    } else {
        error($next_token, "write");
    }
    print("...........CLOSING WRITE STATEMENT........\n") if $debug;
}

sub structured_stmt {
    print("...........STARTING STRUCTURED STATEMENT........\n") if $debug;
    if(is_if_stmt()) {
        if_stmt();
    } elsif(is_while_stmt()) {
        while_stmt();
    } else {
        compound_stmt();
    }
    print("...........CLOSING STRUCTURED STATEMENT........\n") if $debug;
}

sub is_if_stmt {
    if($next_token eq "if") {
        return 1;
    } else {
        return 0;
    }
}

sub is_while_stmt {
    if($next_token eq "while") {
        return 1;
    } else {
        return 0;
    }
}

sub if_stmt {
    print("...........STARTING IF STATEMENT........\n") if $debug;
    if($next_token eq "if") {
        lex();
        expression();

        if($next_token eq "then") {
            lex();
            stmt();
        } else {
            error($next_token, "then");
        }

        if($next_token eq "else") {
            lex();
            stmt();
        } else {
            lex();
        }
    } else {
        error($next_token, "if");
    }
    print("...........CLOSING IF STATEMENT........\n") if $debug;
}

sub while_stmt {
    print("...........STARTING WHILE STATEMENT........\n") if $debug;
    if($next_token eq "while") {
        lex();
        expression();

        if($next_token eq "do") {
            lex();
            stmt();
        } else {
            error($next_token, "do");
        }
    } else {
        error($next_token, "while");
    }
    print("...........CLOSING WHILE STATEMENT........\n") if $debug;
}

sub expression {
    print("...........STARTING EXPRESSION........\n") if $debug;
    simple_expr();
    if(is_relational_operator()) {
        lex();
        simple_expr();
    }
    print("...........CLOSING EXPRESSION........\n") if $debug;
}

sub is_relational_operator {
    if($next_token eq "=" || $next_token eq "<>" || $next_token eq "<=" || $next_token eq "<" || $next_token eq ">=" || $next_token eq ">") {
        return 1;
    } else {
        return 0;
    }
}

sub is_sign {
    if($next_token eq "+" || $next_token eq "-") {
        return 1;
    } else {
        return 0;
    }
}

sub is_term {
    if(is_factor()) {
        return 1;
    } else {
        return 0;
    }
}

sub is_factor {
    if($next_token eq "VARIABLE") {
        return 1;
    } else {
        return 0;
    }
}

sub simple_expr {
    print("...........STARTING SIMPLE EXPRESSION........\n") if $debug;
    if(is_sign()) {
        lex();
    }
    term();
    while(is_adding_operator()) {
        lex();
        term();
    }
    print("...........CLOSING SIMPLE EXPRESSION........\n") if $debug;
}

sub is_adding_operator {
    if(is_sign()) {
        return 1;
    } else {
        return 0;
    }
}

sub term {
    print("...........STARTING TERM........\n") if $debug;
    factor();
    while(is_multiplying_operator()) {
        lex();
        factor();
    }
    print("...........CLOSING TERM........\n") if $debug;
}

sub is_multiplying_operator {
    if($next_token eq "*" || $next_token eq "/") {
        return 1;
    } else {
        return 0;
    }
}

sub factor {
    print("...........STARTING FACTOR........\n") if $debug;
    if($next_token eq "VARIABLE") {
        print "MATCHES VARIABLE IN FACTOR.\n" if $debug;
        lex();
    } elsif($next_token eq "CONSTANT") {
        print "MATCHES CONSTANT IN FACTOR.\n" if $debug;
        lex();
    } else {
        print "MATCHES EXPRESSION IN FACTOR.\n" if $debug;
        lex();
        expression();

        if($next_token eq ")") {
            lex();
        } else {
            error($next_token, ") in factor");
        }
    }
    print("...........CLOSING FACTOR........\n") if $debug;
}

# method for error, pass in what we see and what we expected respectively
sub error {
    my($actual, $expected) = @_;
    print "Error: Saw >$actual<, but expected >$expected<.\n";
    die "Program stopped due to parsing error.\n";
}