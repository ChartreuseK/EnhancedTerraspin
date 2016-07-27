# Enchanced Terraspin
BASIC Month: Terraspin
<http://reddit.com/r/RetroBattlestations>
Written by FozzTexx
Modified for TRS-80 Model 100 by ChartreuseK
Enhanced functions "APSFERK" by ChartreuseK

### Disk I/O
The file I/O in terraspin-m100-file.bas is written for the TRS-80 Model 100.
File I/O should be portable to most BASICs with some form of Disk I/O with a few changes to the syntax.
"C$ = INPUT$(1,1)" can be replaced by a function that reads one character from a file. 
"OPEN FN$ FOR INPUT AS 1" should be replaced by something that opens a file for input
"CLOSE 1" should be replaced by something that closes the open file.
If your BASIC has a way of rewinding a file then CLOSE+OPEN can be replaced by a rewind. 
If your BASIC supports random access file I/O. The parts in the ')' and 'R' commands that seek through the file can be replaced by the appropriate command from your BASIC.



   |Original commands
:---:|---
*integer* | Push value onto stack
(	| 	Push current IP onto stack (originally intended for loops)
)   |   Pop BP (val pushed by '(') and a loop counter variable off stack
	|   Decrement loop counter, if < 1 then continue to next byte
	|   else push new loop counter and BP back onto stack, and jump to BP
M	|   Pop V off stack, Move 'turtle' V units in current direction, drawing if pen down
T	|   Pop V off stack, Turn 'turtle' V degrees (ccw)
U	|   Lift pen up (won't draw if moving)
D	|   Place pen down (will draw if moving)


   |Added enhanced commands
:---:|---
,	| 	Used to seperate two adjacent numbers to push on stack
A   |   Pop top two values on stack, push sum
P	|	Duplicate top value on stack
S	| 	Pop top two values on stack, push difference (SK(SP-1) - SK(SP))
F	|	Swap top two values on stack
E	|	Pop V from stack, Exchange top of stack with value at position SP-V in stack
R	|	Pop V off stack, set IP=V ie. Return, Push IP using (
K	| 	Pop top value off stack
C   |   Call subroutine, pop address off stack, push current IP, jump to address
X   |   Pop top two values on stack, push SK(SP-1) * SK(SP)
Q   |   Pop top two values on stack, push SK(SP-1) / SK(SP)

