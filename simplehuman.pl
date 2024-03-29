# simplehuman.pl
# this file contains a very simple version of the captcha quiz.
# its purpose is to showcase the basic functionality as set in the design document.
# a more complex (and possibly bloated) version can be found at areyouhuman.pl.

#!/usr/bin/perl
use strict;
use warnings;
use Switch; 

my @operators = {"+","-","*","/"};
my $quota = 4;
my $maxquestions = 5;
my $difficulty = 10;

my $loop = 1;
my($questionnumber, $correctanswers, $number1, $number2, $correct, $operator);

sub random() {
	my $random = int(rand($difficulty)+1);
	$random;
}

while ($loop == 1){
	$questionnumber = 1;
	$correctanswers = 0;
	
	print "Hello, please prove that you're not a computer program.\n";
	print "Prove this by correcly answering $quota out of $maxquestions.\n\n";
	
		while(($questionnumber ne $maxquestions) && ($correctanswers ne $quota)) {
			$number1 = random();
			$number2 = random();
			
			$operator = $operators[rand(@operators)];
			
			switch ($operator) { # there's bound to be a better way to do this
				case "+" {
					$correct = $number1 + $number2;
				}
				case "-" {					
					$correct = $number1 - $number2;
				}
				case "*" {
					$correct = $number1 * $number2;
				}
				case "/" {
					$correct = $number1 / $number2;
				}
				else {
					# shouldn't happen
					die "Unknown operator picked!";
				}
			}
			print "Question $questionnumber: What is $number1 $operator $number2?";
			
			my $input = <STDIN>;
			chomp($input);
		
			if ($input == $correct) {
				$correctanswers += 1;
			}
		}
	print "You scored $correct/$questionnumber, thank you.";
	
	sleep 3;
}
