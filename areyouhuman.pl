#!/usr/bin/perl
use strict;
use warnings;
use Switch; # http://perldoc.perl.org/Switch.html
use Term::ANSIColor; # http://perldoc.perl.org/Term/ANSIColor.html
use List::Util qw(shuffle); # http://www.perlhowto.com/arrange_the_elements_of_an_array_in_random_order
# initialise configuration variables and their defaults
my $numquestions = 5; # number of questions the user is prompted
my $quota = 4;        # number of questions the user must ask correctly
my @questiontypes = ("bank","math","alphabet","odd"); #"math","alphabet","odd","bank"); # question types used [math alphabet odd bank]
my $difficulty = 5; # defines the maximum size of math questions
$| = 0;
my $debug = 0; # 0 = no echoes
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

sub randomFile {
	my $directory = $_[0];
	opendir(DIR,$directory);
	my @files = readdir(DIR);
	closedir(DIR);
	my $return = ".";
	while (substr($return,0,1) eq "."){
		$return = $files[int(rand(@files))];
	}
	debug(3,"\nRandom file! $return selected\n");
	$return=$directory."/".$return; #prepend dir
	$return;
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

sub debug {
	# display a debug message
	if ($debug ge $_[0]){
		print color "yellow";
		print $_[1];
		print color "reset";
	}
}
sub fileArray { # sticks all the shizzle in a file into an array
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

# introduction
print "Hello, please prove that you are not a computer program.\n";
print "Prove this by correctly answering $quota out of $numquestions correctly.\n\n";

# internal vars
my ($corrans, $correct, $questionnumber, $success, $questiontype);
$corrans = 0;


debug(1,"*** DEBUG MODE ON ***\n\n\n"); # announce debug mode if it's on

while (1) { # infinite loop D:
	$questionnumber = 0;
	$success = 0;
	$corrans = 0;
	while ($questionnumber < $numquestions) {
		$questionnumber += 1;
		my $question;
		print "Verification question $questionnumber/$numquestions\n";

		$questiontype = $questiontypes[rand(@questiontypes)];
		debug(1,$questiontype.": ");
		if ($questiontype eq "math"){
			my $number1 = random();
			my $number2 = random();
			my $humanoperator;
			
			my @operators = ("+","-","*","/");
			
			my $rand1 = int(rand(@operators));
			my $operator = $operators[$rand1];
						
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
					while ($validnum != 1) {
						# filter out more complex maths
						if ((($number1 % $number2) == 0) && ($number1 ne 0) && ($number1 ne $number2)) {
							$validnum = 1;
							last;
						} else {
							$number1 = random(); # if complex, reroll
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
		
		} elsif ($questiontype eq "alphabet") {
			my $alph  = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
			my @alphabet = split(//,$alph); # guessing regex here
			my $index = int(rand(@alphabet));
			$correct = $alphabet[$index];
			$index += 1;
			my $ordinal = returnOrdinal($index);
						
			$question = "What is the $index$ordinal letter of the alphabet?\n";
		} elsif ($questiontype eq "odd") {
			# odd one out	
			my $category1 = "foo";
			my $category2 = "foo";
			my $allowable = 0;
			$category1 = randomFile("categories");
			$category2 = randomFile("categories");
			while ($allowable == 0) {
				$allowable = 1;
				debug(3,"1: $category1 | 2: $category2");
				if ($category1 eq $category2) { # impossible question!
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
			
		} elsif ($questiontype eq "bank") {
			my @questions = fileArray(randomFile("questions"));
			debug(3,"@questions selected");
			my (@q, @a, $count, $ques);
			$question = $questions[0];
			$count = 1;
			foreach $ques (@questions) {
				my @currq = split(/\|/, $questions[$count]); # | is the char I've used to split, but it needs escaping
				$q[$count] = $currq[0];
				$a[$count] = $currq[1];
				$count++;
			}
				
			my $randid = int(rand(@q));
			$question =  $question.$q[$randid]."?\n";
#			$question = "";
			
			$correct  = $a[$randid];
		} else {
			die "Invalid question type found; please check your configuration!";
		}
		
		print $question;
		debug(1,"{$correct} ");
		print color "magenta";
		print ">>>";
		print color "reset";
		my $input = <STDIN>;
		chomp($input);
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
	
	if ($success == 1) {
		print "Congratulations, you are probably not a robot.";
		print "\nFor further verification, run voightkampff.pl\n\n";
	} else {
		print "Unfortunately, you did not manage to answer enough questions to pass as a human.";
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
