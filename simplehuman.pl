#!/usr/bin/perl
use strict;
use warnings;

my @operators = {"+","-","*","/"};
my $quota = 4;
my $maxquestions = 5;
my $difficulty = 10;

my $loop = 1;
my $questionnumber;
my $correctanswers;

sub random() {
	my $random = int(rand($difficulty)+1);
	$random;
}

while ($loop == 1){
	$questionnumber = 0;
	$correctanswers = 0;
	
	print "Hello, please prove that you're not a computer program.";
	print "Prove this by correcly answering $quota out of $maxquestions.";
	
		while(($questionnumber ne $maxquestions) && ($correctanswers ne $quota)) {
			my $number1 = random();
			my $number2 = random();
			
			my $operator = $operators[rand(@operators)];
			
			switch ($operand) { # there's bound to be a better way to do this
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
			print "Question $questionnumber: What is $number1$operator$number2?";
			
			my $input = <STDIN>;
			chomp($input);
		
			if ($input == $correct) {
				$correctanswers += 1;
			}
		}
	print "You scored $correct/$questionnumber, thank you.";
	
	sleep 3;
}