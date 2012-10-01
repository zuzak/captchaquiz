#!/usr/bin/perl
use strict;
use warnings;
use Switch; # not sure what this does, but http://perldoc.perl.org/Switch.html seems to need it
use Term::ANSIColor; # http://perldoc.perl.org/Term/ANSIColor.html

# initialise configuration variables and their defaults
my $numquestions = 5; # number of questions the user is prompted
my $quota = 4;        # number of questions the user must ask correctly
my @questiontypes = ("math", "alphabet"); # question types used
my $difficulty;
$difficulty = 10; # defines the maximum size of math questions

my $debug = 1; # turn on to view answers(!)

# language variables
my @plus = ("plus", "added to", "+", "more than");
my @minus = ("minus", "take", "subtracted by", "less");
my @times = ("times", "multiplied by", "by");
my @divide = ("divided by", "divided into", "split between");

##################

#require "config.pl";


if ($numquestions lt $quota) { # check if the config is sane
	die "Too many questions, not enough answers!";
}

sub random() {
	my $random = int(rand($difficulty)+1);
	$random;
}

sub returnOrdinal {
	my $ord = "th";
	my $number = $_[0];
	my $number1 = substr($number, -1); # get last char
	my $number2 = substr($number, -2);
	if (($number2 == 11) || ($number2 == 12) || ($number2 == 13)) {
	 $ord = "th";
	} else {
		switch ($number1){
			case "1" {
				$ord = "st";
			}
			case "2" {
				$ord = "nd";
			}
			case "3" {
				$ord = "rd";
			}
			else { # perl shouted if I removed this
					$ord = "th";
			}
		}
	}
	$ord
}

# introduction
print "Hello, please prove that you are not a computer program.\n";
print "Prove this by correctly answering $quota out of $numquestions correctly.\n\n";

# internal vars
my $corrans;
my $correct;
my $questionnumber;
my $success;
my $questiontype;
$corrans = 0;

if ($debug != 0){
	print color "yellow";
	print "*** DEBUG MODE ON ***\n\n\n";
	print color "reset";
}
while (1) { # infinite loop D:
	$questionnumber = 0;
	$success = 0;
	$corrans = 0;
	while ($questionnumber lt $numquestions) {
		$questionnumber += 1;
		print "Verification question $questionnumber/$numquestions\n";
		$questiontype = $questiontypes[rand(@questiontypes)];
		if ($questiontype eq "math"){
			my $number1 = random();
			my $number2 = random();
	
			my @operands = ("+","-","*","/");
			my $operand = $operands[rand(@operands)];
			my $humanoperand;
			switch ($operand) { # there's bound to be a better way to do this
				case "+" {
					$correct = $number1 + $number2;
					$humanoperand = $plus[rand(@plus)];
				}
				case "-" {
					my $validnum = 0;
					while ($validnum != 1){
						if ($number1 gt $number2) {
							$validnum = 1;
							last;
						} else {
							$number1 = random();
						}
					}
						
					$correct = $number1 - $number2;
					$humanoperand = $minus[rand(@minus)];
				}
				case "*" {
					$correct = $number1 * $number2;
					$humanoperand = $times[rand(@times)];
				}
				case "/" {
					my $validnum = 0;
					while ($validnum != 1) {
						if ((($number1 % $number2) == 0) && ($number1 ne 0) && ($number1 ne $number2)) {
							$validnum = 1;
							last;
						} else {
							$number1 = random();
						}
					}
					$correct = $number1 / $number2;
					$humanoperand = $divide[rand(@divide)];
				}
				else {
					# shouldn't happen
					die "Unknown operand picked!";
				}
			}	
			print "What is $number1 $humanoperand $number2?";
			print "\n";
		
		} elsif ($questiontype eq "alphabet") {
			my $alph  = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
			#my $alph2 = "abcdefghijklmnopqrstuvwxyz";
			my @alphabet = split(//,$alph); # guessing regex here
			#my @alphabet = ('a','b','c','d','e','f','g');
			my $index = int(rand(@alphabet));
			$correct = $alphabet[$index];
			$index += 1;
			my $ordinal = returnOrdinal($index);
						
			print "What is the $index$ordinal letter of the alphabet?\n";
		} elsif ($questiontype eq "odd") {
			# odd one out	
			my @categories;
			opendir(DIR,"categories"); # unsure what DIR is
			@categories = readdir(DIR);

			my $category1;
			my $category2;

			$category1 = $categories[int(rand(@categories))];
			$category2 = $categories[int(rand(@categories))];
			$correct = "placeholder";


			
		} else {
			die "Invalid question type found; please check your configuration!";
		}
		
		if ($debug != 0) {
			print color "blue";
			print "[$questiontype: $correct]";
			print color "reset";
		}
		my $input = <STDIN>;
		chomp($input);
		$input = uc($input); # for alphabet stuff
		if ($input eq $correct) {
			$corrans += 1;
			print color "green";
			print "  correct\n\n";
		} else {
			print color "red";
			print "incorrect\n\n";
		}
		
		print color "reset";
		# as perl didn't seem to like && in the while:
		
		if ($corrans == $quota) { 
			$success = 1;
			last;
			
			
		}
	}
	
	if ($success == 1) {
		print "Congratulations, you are probably not a robot.";
		print "\nFor further verification, run voightkampff.pl\n\n";
	} else {
		print "Unfortunately, you did not manage to answer enough questions to pass as a human.";
		print "\n[$questionnumber asked] [$corrans correct] [$quota required]\n"; # user failed, tell them how
	}

	$| = 1; # disable output buffering for the progress bar thing
	
	print "\n\nRestarting";
	
	my $timer;
	for ($timer = 3; $timer >= 1; $timer--) {
		print ".";
		sleep(1);
	}
	print "\n\n";
	$| = 0; # reenable, just in case
}

die "The end was reached!"; # there's an infinite loop, this should never happen

