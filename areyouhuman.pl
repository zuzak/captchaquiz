#!/usr/bin/perl
#	areyouhuman.pl
#
# Copyright (c) 2012 Douglas 'zuzak' Gardner
#
# Permission is hereby granted, free of charge, to any person obtaining a copy of this software
# and associated documentation files (the "Software"), to deal in the Software without restriction,
# including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense,
# and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so,
# subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED
# TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
# THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF
# CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
# DEALINGS IN THE SOFTWARE.
#
#
#
use strict;
#use warnings;
use Switch; # http://perldoc.perl.org/Switch.html
use Term::ANSIColor; # http://perldoc.perl.org/Term/ANSIColor.html
use List::Util qw(shuffle); # http://www.perlhowto.com/arrange_the_elements_of_an_array_in_random_order
# initialise configuration variables and their defaults
my $numquestions = 5; # number of questions the user is prompted
my $quota = 4;        # number of questions the user must ask correctly
my @questiontypes = ("math","alphabet","bank","odd"); #"math","alphabet","odd","bank"); # question types used [math alphabet odd bank]
my $difficulty = 5; # defines the maximum size of math questions

my $debug = 3; # 0 = no echoes
			   # 1 = show question types and answers
			   # 2 = show file names etc
			   # 3 = splurge verbosity

# language variables
my @plus = ("plus", "added to", "+", "more than");
my @minus = ("minus", "take", "subtracted by", "less");
my @times = ("times", "multiplied by", "by");
my @divide = ("divided by", "divided into", "split between");

$| = 1;
srand; # may the odds be forever in your favour

if ($numquestions lt $quota) { # check if the config is sane
	die "Too many questions, not enough answers!";
}

sub random() {
	my $random = int(rand($difficulty)+1);
	$random;
}

sub randomFile { # returns the name of a random file in a specified directory
	my $directory = $_[0];
	$directory = "/".$directory;
	opendir(DIR,"$directory") || die $!;
	my @files = readdir(DIR);
	closedir(DIR);
	my $return = ".";
	debug(3,"Files found: ".@files);
	while (substr($return,0,1) eq "."){
		
		$return = $files[int(rand(@files))];
		debug(3,"****".$return."\n");
	}
	$return=$directory."/".$return; #prepend dir
	debug(3,"\nRandom file [$return] selected\n");

	$return;
}

sub returnOrdinal { # returns 1st, 2nd, 3rd, 4th etc
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

sub debug {
	# display a debug message
	if ($debug ge $_[0]){
		print color "yellow";
		print $_[1];
		print color "reset";
	}
}
sub fileArray { # sticks all the shizzle in a file into an array, one per line
	my $file = $_[0];
	debug(3,"\nOpening $file...");
	my $line = 0;
	my @dict;

	open(HANDLE, $file) ||	die("$file not found"); # cake or death
	
	my $nextword = <HANDLE>; 

	while ($nextword) {
		chomp($nextword); # remove \n
		debug(3,"\nReading $nextword...");
		if (substr($nextword,0,2) ne "//") { # comments
			$dict[$line] = $nextword;
			$line += 1;
		}
		$nextword = <HANDLE>;
	}
	close(HANDLE);
	debug(3,"\n$file closed..");
	@dict;	

}

# introduction: welcome to the enrichment center
print "Hello, please prove that you are not a computer program.\n";
print "Prove this by correctly answering $quota out of $numquestions correctly.\n\n";

# declare internal vars

debug(1,"*** DEBUG MODE ON ***\n\n\n"); # announce debug mode if it's on

while (1) { # infinite loop D:
	$questionnumber = 0; # the number of questions asked
	$success = 0; # whether they win
	$corrans = 0; # number of correct answers
	while ($questionnumber < $numquestions) {
		$questionnumber += 1;
		my $question;
		print "Verification question $questionnumber/$numquestions\n";

		$questiontype = $questiontypes[rand(@questiontypes)]; # select random category of question
		debug(1,$questiontype.": ");
		switch ($questiontype){
			case "math"{
				my $number1 = random();
				my $number2 = random();
				my $humanoperator;
				
				my @operators = ("+","-","*","/");
			
				my $rand1 = int(rand(@operators));
				my $operator = $operators[$rand1];
				debug(2,"\n$operator selected\n");
				switch ($operator) { # there's bound to be a better way to do this
					case "+" {
						$correct = $number1 + $number2;
						$humanoperator = $plus[rand(@plus)];
					}
					case "-" {
						while ($number1 < $number2) { # if the answer is -ve, reroll
							$number1 = random();
						}
					$correct = $number1 - $number2;
					$humanoperator = $minus[rand(@minus)];
					}
					case "*" {
						$correct = $number1 * $number2;
						$humanoperator = $times[rand(@times)];
					}
					case "/" {
						my $validnum = 0;
						my $timeout = 0; # the program kept hanging, workaround
						while ($validnum != 1) {
							# filter out more complex maths
							if ((($number1 % $number2) == 0) && ($number1 ne 0) && ($number1 ne $number2)) {
								$validnum = 1;
								last;
							} else {
								$number1 = random(); # if complex, reroll
							}
							if ($timeout = 20) { # not in the while bc I want an error message
								debug(2,"\n*** Timeout reached!\n");
								$number1 = 10;
								$number2 = 2;
							}
						}
						$correct = $number1 / $number2;
						$humanoperator = $divide[rand(@divide)];
					}
					else {
						# shouldn't happen
						die "Unknown operator picked!";
					}
				}	
				$question = "What is $number1 $humanoperator $number2?\n";
			}
			case "alphabet" {
			   	my $alph  = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
				my @alphabet = split(//,$alph); # guessing regex here
				my $index = int(rand(@alphabet));

				$correct = $alphabet[$index];
				$index += 1;

				my $ordinal = returnOrdinal($index);
						
				$question = "What is the $index$ordinal letter of the alphabet?\n";
			}
			case "odd" {
				# odd one out	
				my $category1 = "foo";
				my $category2 = "foo";
				my $allowable = 0;
				$category1 = randomFile("categories");
				$category2 = randomFile("categories");
				while ($allowable == 0) {
					$allowable = 1;
					debug(3,"1: $category1 | 2: $category2");
					if ($category1 eq $category2) { # filter out nigh impossible question to answer
						$allowable = 0;
						debug(3,"\nSame category");
						$category1 = randomFile("categories");
					}	
					debug(3,"!");
				}
				debug(3,"*");
				
				my @cat1 = fileArray($category1);
				my @cat2 = fileArray($category2);
				debug(3,"\n C1: @cat1; C2: @cat2");
				my @printwords;
			
				my $wordcount = 0;
				my $allowed = 1;
				while ($wordcount ne int($difficulty/0.75)) {
					my $word = $cat1[int(rand(@cat1))]; # get random word
					push(@printwords,$word);
					$wordcount++;
				}
				$correct = $cat2[int(rand(@cat2))];
				debug(2,"$category1 - $category2");
				push(@printwords,$correct); # add the odd one out to the pile
			
				@printwords = shuffle(@printwords);
				$question = "Which is the odd one out? <|";
				
				my $option;
				foreach $option (@printwords) {
					$question = $question." $option |";
				}
				$question = $question."> \n";
				
			}
			case "bank" {
				# question bank
				my @questions = fileArray(randomFile("questions"));
				debug(3,"@questions selected");
				my (@q, @a, $count, $ques);
				$question = "<NO QUESTION SET!>";
				$question = $questions[0];
				$count = 1;
				foreach $ques (@questions) {
					my @currq = split(/\|/, $questions[$count]); # | is the char I've used to split, but it needs escaping
					$q[$count] = $currq[0];
					$a[$count] = $currq[1];
					$count++;
				}
					
				my $randid = int(rand(@q));
				$question =  $question."\n".$q[$randid]."?\n";
	#			$question = "";
				
				$correct  = $a[$randid];
			} else {
				die "Invalid question type found; please check your configuration!";
			}
		}	
		my $input = "";
		while ($input eq "") { # disallow blank answers
			print $question;
			debug(1,"{$correct} ");
			print color "magenta";
			print ">>>";
			print color "reset";
			$input = <STDIN>;
			chomp($input);
		}
			$input = uc($input); # for alphabet stuff
		$correct = uc($correct); 
		if ($input eq $correct) {
			$corrans += 1;
			print color "green";
			print "  correct\n\n";
		} else {
			print color "red";
			print "incorrect\n";
			
			debug(2,"          YOU WROTE $input\n");
			debug(2,"         ANSWER WAS $correct\n\n");
		}
		
		print color "reset";
		# as perl didn't seem to like && in the while:
		
		if ($corrans == $quota) { 
			$success = 1;
			last;
			
			
		}
	}
	
	if ($success == 1) { # announce results
		print "Congratulations, you are probably ";
		print color "green";
		print "not a robot";
		print color "reset";
		print ".\nFor further verification, run voightkampff.pl\n\n";
	} else {
		print "Unfortunately, you ";
		print color "red";
		print "did not manage";
		print color "reset";
		print " to answer enough questions to pass as a human.";
		print "\n[$questionnumber asked] [$corrans correct] [$quota required]\n"; # user failed, tell them how
	}

	print "\n\nRestarting";
	
	my $timer;
	for ($timer = 3; $timer >= 1; $timer--) {
		print ".";
		sleep(1);
	}
	print "\n\n";
}

die "The end was reached!"; # there's an infinite loop, this should never happen
