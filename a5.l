%{
#include "y.tab.h"
#include <stdio.h>
#include <string.h>

int line = 1;

int yywrap()
{
	return 1;
}
%}

%%

[ \t] {}

[\n] {++line;yylval.val = line;};

char|int|float|double {yylval.string = strdup(yytext); return(DATATYPE);}

"main" {return MAIN;}

"if" {return IF;}

"else" {return ELSE;}

"for" {return FOR;}

"while" {return WHILE;}

[a-zA-Z][a-zA-Z0-9]* {yylval.string = strdup(yytext); return(ID);}

[0-9]+\.[0-9]+|[0-9]+ {yylval.string = strdup(yytext);return(NUM);}

">="|"<="|"=="|">"|"<" {yylval.string = strdup(yytext);return cOP;}

"=" {return(EQ);}

. {return(yytext[0]);}

%%
