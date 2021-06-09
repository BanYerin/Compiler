LVALUE µþ±â
PUSH 3
PUSH 5
PUSH 3
PUSH 5
/
*
-
:=
LVALUE apple2
PUSH 1
PUSH 2
PUSH 3
*
+
:=
LVALUE banana
PUSH 6
PUSH 3
PUSH 3
PUSH 3
*
*
PUSH 3
/
+
:=
LVALUE °úÀÏ3
RVALUE µþ±â
RVALUE µþ±â
*
RVALUE apple2
-
RVALUE banana
+
:=
HALT
$ -- END OF EXECUTION CODE AND START OF VAR DEFINITIONS --
DW µþ±â
DW apple2
DW banana
DW °úÀÏ3
END
