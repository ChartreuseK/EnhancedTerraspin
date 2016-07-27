100 REM BASIC Month: Terraspin
110 REM http://reddit.com/r/RetroBattlestations
120 REM written by FozzTexx
126	REM modified for TRS-80 Model 100 by ChartreuseK
127 REM enhanced functions "APSFERK" by ChartreuseK
128 REM Reading command from .DO file by ChartreuseK
129 REM Filo I/O should be portable to most basics with some form of Disk I/O
130 REM All occurances of C$ = INPUT$(1,1) can be replaced by a function
131 REM that reads one character from a file. 
132 REM Occurances of OPEN FN$ FOR INPUT AS 1 can be replaced by something to 
133 REM open a file as input starting at the first character
134 REM Occurances of CLOSE 1 should close the open file.
135 REM If your basic has a way of rewinding a file. Close+Open can be replaced by
136 REM a rewind. 

140 REM Model100 BASIC has bitwise operators so much of the line clipping
141 REM logic is simplified compared to the Apple II version.

200 REM === Initialize variables
201 REM === Change the 15 / 4 to match your screens aspect ratio (M-100 is 15:4)
202	REM === Most other computers will be 4:3
210 SW = 240:SH = 64:XS = SW / 1000:YS = (SH * 15) / (1000 * 4)
220 SW = SW - 1:SH = SH - 1
230 PI = 3.14159

250 REM === Set turtle start at center of screen pointing up, pen up
260 TX = 500:TY = SH / YS / 2:TA = 90:TP = 0

270 REM === Set stack size (Default to 10)
280 SD = 10:INPUT "Stack Depth";SD
285 DIM SK(SD)

290 REM === Load the file to read from
300 INPUT "Filename";FN$
310 OPEN FN$ FOR INPUT AS 1

490 CLS

500 REM === Command interpreter
510 IP = 1:SP = 0
511 REM == Read next character from file
520 IF EOF(1) THEN 710
525 C$ = INPUT$(1,1)
530 IF C$ = " " THEN IP = IP + 1:GOTO 520
535 IF C$ = "," THEN IP = IP + 1:GOTO 520
540 IF C$ >= "-" AND C$ <= "9" THEN GOSUB 1210:GOTO 530
550 IF C$ = "(" THEN V = IP:GOSUB 1010
560 IF C$ = ")" THEN GOSUB 2010
570 IF C$ = "M" THEN GOSUB 2510
580 IF C$ = "T" THEN GOSUB 3010
590 IF C$ = "U" THEN GOSUB 3510
600 IF C$ = "D" THEN GOSUB 4010
605 REM === Enhanced Stack Functions
610 IF C$ = "A" THEN GOSUB 5510
615 IF C$ = "P"	THEN GOSUB 6010
620 IF C$ = "S" THEN GOSUB 6510
625 IF C$ = "F" THEN GOSUB 7010
630 IF C$ = "E" THEN GOSUB 7510
635 IF C$ = "R" THEN GOSUB 8010
640	IF C$ = "K" THEN GOSUB 1110
645 IF C$ = "C" THEN GOSUB 8510
650 IF C$ = "X" THEN GOSUB 9010
655 IF C$ = "Q" THEN GOSUB 9510
700 IP = IP + 1
710 IF EOF(1) THEN 710
720 GOTO 520

1000 REM === Push onto stack
1010 SP = SP + 1:SK(SP) = V
1020 RETURN

1100 REM === Pop from stack
1110 V = SK(SP):SP = SP - 1
1120 RETURN

1200 REM === Read in number
1210 N$ = C$
1220 IF EOF(1) THEN 1250
1230 C$ = INPUT$(1,1):IP = IP+1
1240 IF C$ > "-" AND C$ <= "9" THEN N$ = N$ + C$:GOTO 1220
1250 V = VAL(N$):GOSUB 1010
1260 RETURN


1500 REM === Plot a line
1510 LINE(X1,Y1)-(X2,Y2),PSET
1520 RETURN

2000 REM === Loop instruction end
2010 GOSUB 1110:BP = V
2020 GOSUB 1110:LR = V
2030 LR = LR - 1
2040 IF LR < 1 THEN RETURN
2050 V = LR:GOSUB 1010
2060 V = BP:GOSUB 1010
2065 REM = Reposition in file
2070 IF BP < IP THEN GOTO 2110
2080 FOR I=0 TO BP-IP:C$=INPUT$(1,1):NEXT I
2090 GOTO 2150
2100 REM = Rewind file
2110 CLOSE 1
2120 OPEN FN$ FOR INPUT AS 1
2130 FOR I=0 TO BP:C$=INPUT$(1,1):NEXT I
2150 IP = BP
2160 RETURN

2500 REM === Move
2510 GOSUB 1110
2520 LX = V * COS((360 - TA) * PI / 180):LY = V * SIN((360 - TA) * PI / 180)
2530 IF TP > 0 THEN X1 = TX:Y1 = TY:X2 = X1 + LX:Y2 = Y1 + LY:GOSUB 4510
2540 TX = TX + LX:TY = TY + LY
2550 RETURN

3000 REM === Turn
3010 GOSUB 1110
3020 TA = TA + V
3030 IF TA < 0 THEN TA = TA + 360:GOTO 3030
3040 IF TA >= 360 THEN TA = TA - 360:GOTO 3040
3050 RETURN

3500 REM === Pen up
3510 TP = 0
3520 RETURN

4000 REM === Pen down
4010 TP = 1
4020 RETURN

4500 REM === Draw line, clipping if needed
4510 X1 = X1 * XS:X2 = X2 * XS:Y1 = Y1 * YS:Y2 = Y2 * YS
4520 X = X1:Y = Y1:GOSUB 5010:C1 = C
4530 X = X2:Y = Y2:GOSUB 5010:C2 = C
4540 IF C1 = 0 AND C2 = 0 THEN GOSUB 1510:RETURN
4550 IF C1 AND C2 THEN RETURN
4560 C = C1:IF C = 0 THEN C = C2
4570 IF C AND 1 THEN X = X1 + (X2 - X1) * (SH - Y1) / (Y2 - Y1):Y = SH:GOTO 4610
4580 IF C AND 2 THEN X = X1 + (X2 - X1) * (0 - Y1) / (Y2 - Y1):Y = 0:GOTO 4610
4590 IF C AND 4 THEN Y = Y1 + (Y2 - Y1) * (SW - X1) / (X2 - X1):X = SW:GOTO 4610
4600 IF C AND 8 THEN Y = Y1 + (Y2 - Y1) * (0 - X1) / (X2 - X1):X = 0:GOTO 4610
4610 IF C = C1 THEN X1 = X:Y1 = Y:GOTO 4630
4620 X2 = X:Y2 = Y
4630 GOTO 4520

5000 REM === Calculate region code
5010 C = 0
5020 IF Y > SH THEN C = C OR 1
5030 IF Y < 0 THEN C = C OR 2
5040 IF X > SW THEN C = C OR 4
5050 IF X < 0 THEN C = C OR 8
5060 RETURN

5250 REM === Enhanced Stack Functions

5500 REM === Pop top two values on stack, push sum
5510 GOSUB 1110:S1 = V
5520 GOSUB 1110:S2 = V
5530 V = S1 + S2:GOSUB 1010
5540 RETURN


6000 REM === Duplicate top value on stack
6010 GOSUB 1110
6020 GOSUB 1010:GOSUB 1010
6030 RETURN

6500 REM === Pop top two values on stack, push difference
6510 GOSUB 1110:S1 = V
6520 GOSUB 1110:S2 = V
6530 V = S2 - S1:GOSUB 1010
6540 RETURN

7000 REM === Swap top two values on stack
7010 GOSUB 1110:S1 = V
7020 GOSUB 1110:S2 = V
7030 V = S1:GOSUB 1010
7040 V = S2:GOSUB 1010
7050 RETURN

7500 REM === Pop V from stack, Exchange top of stack with value at position SP-V in stack
7510 GOSUB 1110
7520 S1 = SK(SP)
7530 S2 = SK(SP-V)
7540 SK(SP)=S2:SK(SP-V)=S1
7550 RETURN


8000 REM === Pop V off stack, set IP=V ie. Return, Push IP using (
8005 REM ===  Also can be used for arbitrary jumps  ie   15R   jumps to location 15
8010 GOSUB 1110
8015 REM = Reposition in file
8020 IF V < IP THEN GOTO 8060
8030 FOR I=0 TO V-IP:C$=INPUT$(1,1):NEXT I
8040 GOTO 8090
8050 REM = Rewind file
8060 CLOSE 1
8070 OPEN FN$ FOR INPUT AS 1
8080 FOR I=0 TO V:C$=INPUT$(1,1):NEXT I
8090 IP = V
8100 RETURN

8500 REM === Call Subroutine, pop address off stack, push next IP and jump
8510 GOSUB 1110:NP=V
8520 V=IP:GOSUB 1010
8530 V=NP:GOTO 8020

9000 REM === Pop two values off stack, push S1 * S2
9010 GOSUB 1110:S1 = V
9020 GOSUB 1110:S2 = V
9030 V = S1 * S2:GOSUB 1010
9040 RETURN

9500 REM === Pop two values off stack, push S2 / S1
9510 GOSUB 1110:S1 = V
9520 GOSUB 1110:S2 = V
9530 V = S2 / S1:GOSUB 1010
9540 RETURN
