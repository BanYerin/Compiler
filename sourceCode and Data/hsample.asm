$ �ѱ� ���� ��� �׽�Ʈ �� �ĸ�Ʈ ó��
$  '$'ǥ�÷� ���� �� �������� �ĸ�Ʈ�� ó����
$ 
PUSH	176		$ 0xB0 = 176  '��' �ڵ��� ù��° ����Ʈ
OUTCH
PUSH	161		$ 0xA1 = 161   '��'�ڵ��� �ι�° ����Ʈ
OUTCH
PUSH	32
OUTCH
LVALUE ��
INNUM	
:=
PUSH	179		$ 0xB3 = 179 '��' �ڵ��� ù��° ����Ʈ
OUTCH
PUSH	170		$ 0xAA = 170  '��' �ڵ��� �ι�° ����Ʈ
OUTCH
PUSH	32
OUTCH
LVALUE ��
INNUM
:=
RVALUE ��
RVALUE ��
-
GOMINUS	OUT
LVALUE		MAX
RVALUE	��
:=
GOTO	OUT1
LABEL	OUT
LVALUE		MAX
RVALUE	��
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
$ ������ ����
$
DW	��
DW	��
DW	MAX
END