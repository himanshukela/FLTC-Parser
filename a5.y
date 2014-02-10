%{
#include <stdio.h>
#include <string.h>
#include "symbol.h"
#include "stack.h"
#include "quad.h"

int vIndex = 1;
int sIndex = 0;
int iIndex = 1;
int k;
int f_start=0,f_end=0;

char temp[10],t[5];

struct stack s;
struct stack1 q,cstack;

struct quad buffer[5];

void eval(char *);
void typeCast();

%}

%union{
	char *string;
	int val;
};

%token MAIN IF ELSE FOR WHILE EQ
%token<string> DATATYPE ID NUM cOP

%left '-' '+'
%left '*' '/'

%type<string> E

%%

P		:	DATATYPE MAIN '(' ')' {init(&s);init1(&cstack);init1(&q);}

			BLOCK {insert_instr("NULL","NULL","NULL","END");}
		;

BLOCK	:	'{' LINES '}'
		;
		
LINES	:	BLOCK
		|
			LINES STMT
		|
			STMT
		;
		
STMT	:	DEC
		|
			EXE
		;
		
DEC		:	DATATYPE VLIST 			{setSymbolType($1);}
		;

VLIST	:	ID ',' VLIST 			{insertSymbol($1);}
		|
			ID ';' 					{insertSymbol($1);}
		;
		
EXE		:	EXP ';'
		|
			CONDITIONAL
		|
			WHILE_LOOP
		|
			FOR_LOOP
		;
		
FOR_LOOP:	FOR FOR_C BLOCK	{
								//
								int i;
								for(i=0;i<f_end-f_start;i++)
								{
									Q[iIndex] = buffer[i];
									Q[iIndex].no = iIndex;
									iIndex++;
								}
								
								k = pop1(&q);
								insert_goto(k,iIndex+1);
								strcpy(Q[k]._operator,"FOR");	//
								insert_instr("NULL","NULL","NULL","NULL");
								insert_goto(iIndex-1,k-1);
							}
		;

FOR_C	:	'(' EXP ';' CONDITION ';' 			{f_start = iIndex;} 
										EXP ')' {
													int i,j=0;
													f_end = iIndex;
													for(i=f_start;i<f_end;i++)
													{
														buffer[j] = Q[i];
														j++;
													}
													iIndex = f_start;
												}
		;
		
WHILE_LOOP	:	WHILE '(' CONDITION ')' BLOCK 	{
													k = pop1(&q);
													insert_goto(k,iIndex+1);
													strcpy(Q[k]._operator,"WHILE");	//
													insert_instr("NULL","NULL","NULL","NULL");
													insert_goto(iIndex-1,k-1);
												}
			;
		
CONDITIONAL	:	IF_ELSE_STMT
			|
				IF_STMT					{pop1(&q);}
			;
		
IF_ELSE_STMT: 	IF_STMT 			{
										k = pop1(&q);
										insert_goto(k,iIndex+1);
									}

				//ELSE BLOCK
				ELSE 				{
										insert_instr("NULL","NULL","NULL","NULL");
										push1(&q,iIndex-1);
										insert_instr("ELSE","NULL","NULL","NULL");
									}
									
				BLOCK				{
										k = pop1(&q);
										insert_goto(k,iIndex);
									}
			;

IF_STMT 	:	IF '(' CONDITION ')' BLOCK 	{
												k = pop1(&q);
												strcpy(Q[k]._operator,"IF");	//
												insert_goto(k,iIndex);
												push1(&q,k);
											}
			;
		
CONDITION	:	ID cOP ID			{
										checkSymbol($1);
										checkSymbol($3);
										strcpy(temp,"t");
										sprintf(t,"%d",vIndex);
										strcat(temp,t);							
										insert_instr($2,$1,$3,temp);
										insert_instr("",temp,"FALSE","");
										push1(&q,iIndex-1);
										vIndex++;
									}
			|
				ID cOP NUM			{
										checkSymbol($1);
										strcpy(temp,"t");
										sprintf(t,"%d",vIndex);
										strcat(temp,t);							
										insert_instr($2,$1,$3,temp);
										insert_instr("",temp,"FALSE","");
										push1(&q,iIndex-1);
										vIndex++;
									}
			|
				ID					{
										checkSymbol($1);
										insert_instr("",$1,"FALSE","");
										push1(&q,iIndex-1);
										vIndex++;
									}
			;
	
EXP		:	ID EQ E 				{
										char *op1,*type;
										int t1,t2;
										checkSymbol($1);
					
										op1 = pop(&s);
										if(strstr(op1,"t"))
										{
											t1 = pop1(&cstack);	
										}
										else
											t1 = getType(op1);
										
										t2 = getType($1);
										
										if(t1!=t2)
										{
											type = fetchType(t1);
											insert_instr(type,op1,"NULL",$1);
										}
										else
											insert_instr("=",op1,"NULL",$1);
									}
		;

E		: 	E '+' E 				{ eval("+");}
		|
		  	E '-' E 				{ eval("-");}
		|
			E '*' E 				{ eval("*");}
		|
			E '/' E 				{ eval("/");}
		|
			'(' E ')'				{}
		|
			NUM 					{ push(&s,$1);}
		|
			ID 						{ 
										checkSymbol($1);
										push(&s,$1);
									}
		;

%%

extern FILE *yyin;

int main()
{
	FILE *fp = fopen("test5.c","r");
	if(fp==NULL)
	{
		printf("\nFile does not exist !\n");
		return -1;
	}
	yyin = fp;
	
	while(!feof(yyin))
	{
		yyparse();
	}
	
	displaySymtab();
	displayQuad();
	writeQuad();
	return 0;
}

yyerror(char *s)
{
	printf("\n**ERROR** : %s LINE %d\n",s,line);
}

void eval(char *operator)
{
	char *op1,*op2;
	char temp[10],t[5];
	
	typeCast();
	op2 = pop(&s);
	op1 = pop(&s);
	strcpy(temp,"t");
	sprintf(t,"%d",vIndex);
	strcat(temp,t);							
	insert_instr(operator,op1,op2,temp);
	push(&s,temp);
	vIndex++;
}

void typeCast()
{
	char *op1,*op2,*t1,*t2,*t;
	int type1,type2;
	
	op2 = pop(&s);
	op1 = pop(&s);
	
	if(strstr(op1,"t"))
	{
		type1 = pop1(&cstack);	
	}
	else
		type1 = getType(op1);
	
	if(strstr(op2,"t"))
	{
		type2 = pop1(&cstack);
	}
	else
		type2 = getType(op2);
	
	strcpy(temp,"t");
	sprintf(t,"%d",vIndex);
	strcat(temp,t);	
	
	if(type1==type2)
	{
		push1(&cstack,type1);
		//printf("%s %s %s",op1,op2,t1);
		push(&s,op1);
		push(&s,op2);
	}
	else if(type1 < type2)
	{	
		t2 = fetchType(type2);
		push1(&cstack,type2);	
		insert_instr(t2,op1,"NULL",temp);
		push(&s,temp);
		push(&s,op2);
		vIndex++;
	}
	else
	{
		t1 = fetchType(type1);
		push1(&cstack,type1);								
		insert_instr(t1,op2,"NULL",temp);
		push(&s,op1);
		push(&s,temp);
		vIndex++;
	}
}
