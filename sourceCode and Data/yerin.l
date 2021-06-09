%{
#include <string.h>
#include "yerin.h"
#define MAXSYM	100
#define	MAXSYMLEN	20
char symtbl[MAXSYM][MAXSYMLEN];
int lineno=1;
int insertsym(); //�ɺ����̺��� ���ڿ��� �����ϴ� �Լ�
int maxsym=0; //�ɺ����̺��� �ִ� �ε���
char s[30]; //���ڿ��� ���� �迭
int temp;

%}
sp		[ \t]
ws		{sp}+
nl		\n
eletter	[A-Za-z]
hletter	[\xb0-\xfe][\xa0-\xfe]
letter	({eletter}|{hletter})
digit	[0-9]
id		{letter}({letter}|{digit})*


%%
{ws}	{/* do nothing */}
{nl}	{lineno++;}
���ϱ�		{return(ADD); /*��ū ��ȯ*/}
����		{return(SUB); /*��ū ��ȯ*/}
���ϱ�		{return(MUL); /*��ū ��ȯ*/}
������		{return(DIV); /*��ū ��ȯ*/}
������		{return(MOD); /*��ū ��ȯ*/}
����		{return(SQUARE); /*��ū ��ȯ*/}
������		{return(CUBE); /*��ū ��ȯ*/}
:=		{return(ASSGN); /*��ū ��ȯ*/}
;		{return(STMTEND); /*��ū ��ȯ*/}
����		{return(START); /*��ū ��ȯ*/}
��		{return(END); /*��ū ��ȯ*/}
{id}	{
	strcpy(s, yytext); //��Ī�� ���ڿ� yytext�� s�� ����
	temp=insertsym(s); //���ڿ� s�� �ɺ����̺��� �����ϰ� �ش� ��ġ �ε����� ��ȯ�޾� temp�� ����(s�� �ɺ����̺��� �̹� ������ ���� ���� ��ġ �ε����� ��ȯ����)
	yylval=MakeNode(ID, temp); //��ū�� ��ū���� �Ķ���ͷ� �Ѱ��־� ��带 �����ϰ�, �ش� ����� �����͸� ��ȯ�޾� yylval(��ū�� �Ӽ�)�� ����
	return(ID); //��ū ��ȯ
	}
{digit}+	{
		sscanf(yytext, "%d", &temp); //��Ī�� ���ڿ� yytext�� ���������� �о� temp�� ����
		yylval=MakeNode(NUM, temp); //��ū�� ��ū���� �Ķ���ͷ� �Ѱ��־� ��带 �����ϰ�, �ش� ����� �����͸� ��ȯ�޾� yylval(��ū�� �Ӽ�)�� ����
		return(NUM); //��ū ��ȯ
		}
.		{printf("invalid token %s\n", yytext); /*���๮�� ���� ��� �ٸ� ���ڰ� ���� "��ȿ���� ���� ��ū" �̶�� ���*/}
%%


//�ɺ����̺��� ���ڿ��� �����ϴ� �Լ�: ���ڿ��� ������ �ɺ����̺��� ������ �� �ش� ��ġ �ε����� ��ȯ, ���ڿ��� ������ �ش� ���ڿ��� ��ġ �ε����� ��ȯ
int insertsym(s)
char *s;
{
int i;

	for(i=0;i<maxsym; i++) { //�ɺ����̺��� ó������ ������ ������ ��
		if(strcmp(s, symtbl[i])==0) return(i); //s�� ���� ���ڿ��� �ɺ����̺��� ������ �ش� ���ڿ��� ��ġ �ε����� ��ȯ
		}
	if (i<MAXSYM-1) { //s�� ���� ���ڿ��� �ɺ����̺��� ������ �ɺ����̺��� ������ �ε����� s�� �ְ�, �ɺ����̺��� �ִ� �ε����� 1������ ��, ���Ե� ���ڿ��� ��ġ �ε����� ��ȯ 
		strcpy(symtbl[maxsym],s);
		maxsym++;
		return(maxsym-1);
		}
	else
		{printf("symbol table overflow\n");}
	return(0);
}

yywrap() {}