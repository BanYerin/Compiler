%{
#include <stdio.h>
#include <string.h>
#include <stdlib.h>

#define DEBUG	0

#define	 MAXSYM	100
#define	 MAXSYMLEN	20
#define	 MAXTSYMLEN	15
#define	 MAXTSYMBOL	MAXSYM/2

#define STMTLIST 500

//구조체형 노드타입 정의
typedef struct nodeType {
	int token; //토큰
	int tokenval; //토큰값
	struct nodeType *son; //자식 노드를 가리키는 포인터
	struct nodeType *brother; //형제 노드를 가리키는 포인터
	} Node;

#define YYSTYPE Node* //yylval(토큰의 속성)을 Node* 형으로 정의(yacc 뿐만 아니라 lex에도 적용됨)
	
int tsymbolcnt=0; //심볼 카운터
int errorcnt=0; //에러 카운터

FILE *yyin;
FILE *fp;

extern char symtbl[MAXSYM][MAXSYMLEN]; //lex에서 사용했던 심볼테이블
extern int maxsym; //lex에서 사용했던 심볼테이블의 최대 인덱스
extern int lineno; //lex에서 사용했던 줄번호

void DFSTree(Node*); //깊이 우선 탐색 함수
Node * MakeOPTree(int, Node*, Node*); //덧셈, 뺄셈, 곱셈, 나눗셈 연산 AST 생성 함수
Node * MakeModOPTree(Node*, Node*); //나머지 연산 AST 생성 함수
Node * MakeSquareOPTree(Node* operand); //제곱 연산 AST 생성 함수
Node * MakeCubeOPTree(Node* operand); //세제곱 연산 AST 생성 함수
Node * MakeNode(int, int); //단일 노드 생성 함수
Node * MakeListTree(Node*, Node*); //'stmt_list : stmt_list stmt | stmt' 에 해당하는 문법규칙 처리 함수
void codegen(Node* ); //파라미터를 AST의 루트로 하는 코드를 생성하는 함수
void prtcode(int, int); //토큰에 따라 해당하는 토큰값을 출력하는 함수

void dwgen(); //변수에 대한 메모리 공간을 확보하는 함수
int	gentemp();
void assgnstmt(int, int);
void numassgn(int, int);
void addstmt(int, int, int);
void substmt(int, int, int);
int insertsym(char *);
%}

//토큰 정의
%token	ADD SUB ASSGN ID NUM STMTEND START END ID2 MUL DIV MOD SQUARE CUBE
%right ASSGN
%left ADD SUB
%left MUL DIV MOD
%left SQUARE CUBE



%%
program	: START stmt_list END	{ if (errorcnt==0) {codegen($2); dwgen();} }
		;

stmt_list: 	stmt_list stmt 	{$$=MakeListTree($1, $2);}
		|	stmt			{$$=MakeListTree(NULL, $1);}
		| 	error STMTEND	{ errorcnt++; yyerrok;}
		;

stmt	: 	ID ASSGN expr1 STMTEND	{ $1->token = ID2; $$=MakeOPTree(ASSGN, $1, $3);}
		;

expr1	:	expr1 ADD expr2	{ $$=MakeOPTree(ADD, $1, $3); }
		|	expr1 SUB expr2	{ $$=MakeOPTree(SUB, $1, $3); }
		|	expr2
		;

expr2	: 	expr2 MUL term	{ $$=MakeOPTree(MUL, $1, $3); }
		|	expr2 DIV term	{ $$=MakeOPTree(DIV, $1, $3); }
		|	term;

term	:	ID		{ /* ID node is created in lex */ }
		|	NUM		{ /* NUM node is created in lex */ }
		|	term SQUARE		{ $$=MakeSquareOPTree($1); }
		|	term CUBE		{ $$=MakeCubeOPTree($1); }		
		|	term MOD term	{ $$=MakeModOPTree($1, $3); }
		;


%%
int main(int argc, char *argv[]) 
{
	printf("\nYerin compiler v1.1\n");
	printf("********** <2017038023 BanYerin - Compiler assignment> **********\n");
	
	if (argc == 2)
		yyin = fopen(argv[1], "r");
	else {
		printf("Usage: cbu inputfile\noutput file is 'a.asm'\n");
		return(0);
		}
		
	fp=fopen("a.asm", "w");
	
	yyparse();
	
	fclose(yyin);
	fclose(fp);

	if (errorcnt==0) 
		{ printf("Successfully compiled. Assembly code is in 'a.asm'.\n");}
}

yyerror(s)
char *s;
{
	printf("%s (line %d)\n", s, lineno);
}

//덧셈, 뺄셈, 곱셈, 나눗셈 연산 AST 생성 함수
Node * MakeOPTree(int op, Node* operand1, Node* operand2)
{
Node * newnode; //연산자 노드

	newnode = (Node *)malloc(sizeof (Node)); //연산자 노드 생성
	
	newnode->token = op;
	newnode->tokenval = op;
	newnode->son = operand1;
	newnode->brother = NULL;
	operand1->brother = operand2;
	return newnode;
}

//나머지 연산 AST 생성 함수
Node * MakeModOPTree(Node* operand1, Node* operand2)
{
Node * newnode; //뺄셈 연산자 노드
Node * newnode1; //첫번째 피연산자 노드
Node * newnode2; //곱셈 연산자 노드
Node * newnode3; //두번째 피연산자 노드
Node * newnode4; //나눗셈 연산자 노드
Node * newnode5; //첫번째 피연산자 노드
Node * newnode6; //두번째 피연산자 노드

	newnode = MakeNode(SUB, SUB); //뺄셈 연산자 노드 생성
	newnode1 = MakeNode(operand1->token, operand1->tokenval); //첫번째 피연산자 노드 생성
	newnode2 = MakeNode(MUL, MUL); //곱셈 연산자 노드 생성
	newnode3 = MakeNode(operand2->token, operand2->tokenval); //두번째 피연산자 노드 생성
	newnode4 = MakeNode(DIV, DIV); //나눗셈 연산자 노드 생성
	newnode5 = MakeNode(operand1->token, operand1->tokenval); //첫번째 피연산자 노드 생성
	newnode6 = MakeNode(operand2->token, operand2->tokenval); //두번째 피연산자 노드 생성
	
	newnode->son = newnode1;
	newnode1->brother = newnode2;
	newnode2->son = newnode3;
	newnode3->brother = newnode4;
	newnode4->son = newnode5;
	newnode5->brother = newnode6;
	return newnode;
}

//제곱 연산 AST 생성 함수
Node * MakeSquareOPTree(Node* operand)
{
Node * newnode; //곱셈 연산자 노드
Node * newnode1; //피연산자 노드
Node * newnode2; //피연산자 노드

	newnode = MakeNode(MUL, MUL); //곱셈 연산자 노드 생성
	newnode1 = MakeNode(operand->token, operand->tokenval); //피연산자 노드 생성
	newnode2 = MakeNode(operand->token, operand->tokenval); //피연산자 노드 생성
	
	newnode->son = newnode1;
	newnode1->brother = newnode2;
	return newnode;
}

//세제곱 연산 AST 생성 함수
Node * MakeCubeOPTree(Node* operand)
{
Node * newnode; //곱셈 연산자 노드
Node * newnode1; //피연산자 노드
Node * newnode2; //곱셈 연산자 노드
Node * newnode3; //피연산자 노드
Node * newnode4; //피연산자 노드

	newnode = MakeNode(MUL, MUL); //곱셈 연산자 노드 생성
	newnode1 = MakeNode(operand->token, operand->tokenval); //피연산자 노드 생성
	newnode2 = MakeNode(MUL, MUL); //곱셈 연산자 노드 생성
	newnode3 = MakeNode(operand->token, operand->tokenval); //피연산자 노드 생성
	newnode4 = MakeNode(operand->token, operand->tokenval); //피연산자 노드 생성
	
	newnode->son = newnode1;
	newnode1->brother = newnode2;
	newnode2->son = newnode3;
	newnode3->brother = newnode4;
	return newnode;
}

//단일 노드 생성 함수
Node * MakeNode(int token, int operand)
{
Node * newnode;

	newnode = (Node *) malloc(sizeof (Node));
	newnode->token = token;
	newnode->tokenval = operand; 
	newnode->son = newnode->brother = NULL;
	return newnode;
}

//'stmt_list : stmt_list stmt | stmt' 에 해당하는 문법규칙 처리 함수
Node * MakeListTree(Node* operand1, Node* operand2)
{
Node * newnode;
Node * node;

	if (operand1 == NULL){
		newnode = (Node *)malloc(sizeof (Node));
		newnode->token = newnode-> tokenval = STMTLIST;
		newnode->son = operand2;
		newnode->brother = NULL;
		return newnode;
		}
	else {
		node = operand1->son;
		while (node->brother != NULL) node = node->brother;
		node->brother = operand2;
		return operand1;
		}
}

//파라미터를 AST의 루트로 하는 코드를 생성하는 함수
void codegen(Node * root)
{
	DFSTree(root);
}

//깊이 우선 탐색 함수
void DFSTree(Node * n)
{
	if (n==NULL) return;
	DFSTree(n->son);
	prtcode(n->token, n->tokenval);
	DFSTree(n->brother);
	
}

//토큰에 따라 해당하는 토큰값을 출력하는 함수
void prtcode(int token, int val)
{
	switch (token) {
	case ID:
		fprintf(fp,"RVALUE %s\n", symtbl[val]);
		break;
	case ID2:
		fprintf(fp, "LVALUE %s\n", symtbl[val]);
		break;
	case NUM:
		fprintf(fp, "PUSH %d\n", val);
		break;
	case ADD:
		fprintf(fp, "+\n");
		break;
	case SUB:
		fprintf(fp, "-\n");
		break;
	case MUL:
		fprintf(fp, "*\n");
		break;
	case DIV:
		fprintf(fp, "/\n");
		break;	
	case ASSGN:
		fprintf(fp, ":=\n");
		break;
	case STMTLIST:
	default:
		break;
	};
}


/*
int gentemp()
{
char buffer[MAXTSYMLEN];
char tempsym[MAXSYMLEN]="TTCBU";

	tsymbolcnt++;
	if (tsymbolcnt > MAXTSYMBOL) printf("temp symbol overflow\n");
	itoa(tsymbolcnt, buffer, 10);
	strcat(tempsym, buffer);
	return( insertsym(tempsym) ); // Warning: duplicated symbol is not checked for lazy implementation
}
*/

//변수에 대한 메모리 공간을 확보하는 함수
void dwgen()
{
int i;
	fprintf(fp, "HALT\n");
	fprintf(fp, "$ -- END OF EXECUTION CODE AND START OF VAR DEFINITIONS --\n");

// Warning: this code should be different if variable declaration is supported in the language 
	for(i=0; i<maxsym; i++) 
		fprintf(fp, "DW %s\n", symtbl[i]);
	fprintf(fp, "END\n");
}

