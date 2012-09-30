CAPTCHA quiz
============

Purpose
-------
This program attempts to determine if a user is a human or an automated process ('bot').

It does so by asking the user several questions. If a certain number of questions are 
correct, the user is determined to be human.

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
