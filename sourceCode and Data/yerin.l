%{
#include <string.h>
#include "yerin.h"
#define MAXSYM	100
#define	MAXSYMLEN	20
char symtbl[MAXSYM][MAXSYMLEN];
int lineno=1;
int insertsym(); //심볼테이블에 문자열을 삽입하는 함수
int maxsym=0; //심볼테이블의 최대 인덱스
char s[30]; //문자열을 담을 배열
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
더하기		{return(ADD); /*토큰 반환*/}
빼기		{return(SUB); /*토큰 반환*/}
곱하기		{return(MUL); /*토큰 반환*/}
나누기		{return(DIV); /*토큰 반환*/}
나머지		{return(MOD); /*토큰 반환*/}
제곱		{return(SQUARE); /*토큰 반환*/}
세제곱		{return(CUBE); /*토큰 반환*/}
:=		{return(ASSGN); /*토큰 반환*/}
;		{return(STMTEND); /*토큰 반환*/}
시작		{return(START); /*토큰 반환*/}
끝		{return(END); /*토큰 반환*/}
{id}	{
	strcpy(s, yytext); //매칭된 문자열 yytext를 s에 넣음
	temp=insertsym(s); //문자열 s를 심볼테이블에 삽입하고 해당 위치 인덱스를 반환받아 temp에 넣음(s가 심볼테이블에 이미 있으면 삽입 없이 위치 인덱스만 반환받음)
	yylval=MakeNode(ID, temp); //토큰과 토큰값을 파라미터로 넘겨주어 노드를 생성하고, 해당 노드의 포인터를 반환받아 yylval(토큰의 속성)에 넣음
	return(ID); //토큰 반환
	}
{digit}+	{
		sscanf(yytext, "%d", &temp); //매칭된 문자열 yytext를 정수형으로 읽어 temp에 넣음
		yylval=MakeNode(NUM, temp); //토큰과 토큰값을 파라미터로 넘겨주어 노드를 생성하고, 해당 노드의 포인터를 반환받아 yylval(토큰의 속성)에 넣음
		return(NUM); //토큰 반환
		}
.		{printf("invalid token %s\n", yytext); /*개행문자 외의 모든 다른 문자가 오면 "유효하지 않은 토큰" 이라고 출력*/}
%%


//심볼테이블에 문자열을 삽입하는 함수: 문자열이 없으면 심볼테이블에 삽입한 후 해당 위치 인덱스를 반환, 문자열이 있으면 해당 문자열의 위치 인덱스를 반환
int insertsym(s)
char *s;
{
int i;

	for(i=0;i<maxsym; i++) { //심볼테이블의 처음부터 끝까지 훑으며 비교
		if(strcmp(s, symtbl[i])==0) return(i); //s와 같은 문자열이 심볼테이블에 있으면 해당 문자열의 위치 인덱스를 반환
		}
	if (i<MAXSYM-1) { //s와 같은 문자열이 심볼테이블에 없으면 심볼테이블의 마지막 인덱스에 s를 넣고, 심볼테이블의 최대 인덱스를 1증가한 뒤, 삽입된 문자열의 위치 인덱스를 반환 
		strcpy(symtbl[maxsym],s);
		maxsym++;
		return(maxsym-1);
		}
	else
		{printf("symbol table overflow\n");}
	return(0);
}

yywrap() {}