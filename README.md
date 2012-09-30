CAPTCHA quiz
============

Purpose
-------
This program attempts to determine if a user is a human or an automated process ('bot').

It does so by asking the user several questions. If a certain number of questions are 
correct, the user is determined to be human.

Configuration
-------------
The program is designed to be semi-configurable. To configure this program, edit 
config.pl. If a variable is deleted from config.pl, the default will be used.

### Questions
One can edit the number of questions a user is prompted by editing the `$numquestions` 
variable. Similarily, one can edit the number of questions a user must answer correctly 
in order to 'win' and be deemed human by changing the `$quota` variable.

### Types of question
The program supports multiple kinds of question. The question types the user will be 
asked is governed by the `@questiontypes` variable in config.pl.

#### math
The math question type involves basic arithmetic. If the math type is enabled, users will 
be asked to solve simple mathematics problems, such as addition, subtraction, 
multiplication and division.

The maximum size of the numbers in the sums is governed by the `$difficulty` variable.

Problems posed in the math question type are designed to be simple. An attempt has been 
made to filter out more complicated sums: no division question should result in a 
non-integer, for example. Subtraction questions may still result in negative answers.
