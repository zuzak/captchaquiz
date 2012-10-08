CAPTCHA quiz
============

Purpose
-------
This program attempts to determine if a user is a human or an automated process ('bot').

It does so by asking the user several questions. If a certain number of questions are 
correct, the user is determined to be human.

To end the program, send `^c`.

Dependencies
------------
* Requires Switch, which will be removed from the Perl core distribution in the next major release.

Configuration
-------------
The program is designed to be semi-configurable by changing variables near the start of 
areyouhuman.pl.

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

#### alphabet
The alphabet question type contains one question: it asks the user to type the *n*th 
letter of the Roman alphabet. The answers are case insensitive.

#### odd
The odd one out question type prompts the user with several different words. The user
must select the word that is the 'odd one out' in order to answer the question correctly.

This question type is easily configurable, by editing the contents of the `categories` directory.
Each text file should contain a list of words or phrases in a category, one on each line:

```
Jean-Luc Picard
William T. Riker
Geordi La Forge
Tasha Yar
Worf
Q
Welsey Crusher
```

The number of words given to the user to digest is determined from the `$difficulty` variable.

#### bank
The question bank type reads questions from files in the /question directory.
The syntax is thus:

```
questionprefix
question1|answer1
question2|answer2
```

For example:
```
What colour is a
banana|yellow
lemon|yellow
cucumber|green
ubergine|purple
n unripe banana|green
```

### Variables

It is possible to edit the program's functions by editing a few key variables,
located near the start of the file.

#### `$numquestions`
This variable controls the number of questions the user is asked. Setting the variable
to three will require the user to answer three questions before the program is reset.

#### `$quota`
This variable defines how many questions the user must answer correctly in order to pass the test.
Set the quota higher for a more stringent test. `$quota` must not be larger than `$numquestions`.

#### `@questiontypes`
Use this array to determine which question types are used in the test.
Acceptable options are `math`, `alphabet`, `bank`, and `odd`.

#### `$difficulty`
This variable determines how big the numbers in the sums, and the number of options given in the odd-one-out round.

#### `$debug`
Setting this to anything other than 0 will result in debug mode being enabled.
Debug 1 will result in answers and question types being printed to the screen.
Debug 2 will show answers and question types, as well as any file names used when rendering a question.
Debug 3 will splurge a large amount of information, and is generally not useful.

#### Language variables
It is possible to edit the randomly chosen synonyms for the maths questions, by editing `@plus`, `@minus`, `@times`, and `@divide`.

Copyright
---------
> Copyright (c) 2012 Douglas Gardner
> 
> Permission is hereby granted, free of charge, to any person obtaining a copy of this software
> and associated documentation files (the "Software"), to deal in the Software without restriction,
> including without limitation the rights to use, copy, modify, merge, publish, distribute,
> sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is
> furnished to do so, subject to the following conditions:
> 
> The above copyright notice and this permission notice shall be included in all copies or
> substantial portions of the Software.
> 
> THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING
> BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
> NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
> DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
> OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

Attribution that needs to be put somewhere
------------------------------------------

* [Directory to array](http://forums.devshed.com/perl-programming-6/using-perl-to-list-files-in-a-directory-344889.html)
* [Random line in file](http://docstore.mik.ua/orelly/perl3/cookbook/ch08_07.htm)
