PUSH	65
OUTCH
PUSH	32
OUTCH
LVALUE A
INNUM	
:=
PUSH	66
OUTCH
PUSH	32
OUTCH
LVALUE B
INNUM
:=
RVALUE A
RVALUE B
-
GOMINUS	OUT
LVALUE		MAX
RVALUE	A
:=
GOTO	OUT1
LABEL	OUT
LVALUE		MAX
RVALUE	B
:=
LABEL	OUT1
PUSH	77
OUTCH
PUSH	65
OUTCH
PUSH	88
OUTCH
PUSH	61
OUTCH
PUSH	32
OUTCH
RVALUE	MAX
OUTNUM
HALT
DW	A
DW	B
DW	MAX
END