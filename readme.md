# Enchanced Terraspin
BASIC Month: Terraspin
<http://reddit.com/r/RetroBattlestations>
Written by FozzTexx
Modified for TRS-80 Model 100 by ChartreuseK
Enhanced functions "APSFERK" by ChartreuseK


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
S	| 	Pop top two values on stack, push difference
F	|	Swap top two values on stack
E	|	Pop V from stack, Exchange top of stack with value at position SP-V in stack
R	|	Pop V off stack, set IP=V ie. Return, Push IP using (
K	| 	Pop top value off stack

