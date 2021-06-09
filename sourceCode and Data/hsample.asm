$ 한글 변수 사용 테스트 및 컴멘트 처리
$  '$'표시로 부터 줄 끝까지는 컴맨트로 처리됨
$ 
PUSH	176		$ 0xB0 = 176  '가' 코드의 첫번째 바이트
OUTCH
PUSH	161		$ 0xA1 = 161   '가'코드의 두번째 바이트
OUTCH
PUSH	32
OUTCH
LVALUE 가
INNUM	
:=
PUSH	179		$ 0xB3 = 179 '나' 코드의 첫번째 바이트
OUTCH
PUSH	170		$ 0xAA = 170  '나' 코드의 두번째 바이트
OUTCH
PUSH	32
OUTCH
LVALUE 나
INNUM
:=
RVALUE 가
RVALUE 나
-
GOMINUS	OUT
LVALUE		MAX
RVALUE	가
:=
GOTO	OUT1
LABEL	OUT
LVALUE		MAX
RVALUE	나
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
$
$ 데이터 영역
$
DW	가
DW	나
DW	MAX
END