#define MAX 20

extern int vIndex;
extern int sIndex;
extern int line;

struct Symbol
{
	char name[10];
	char type[10];
	
}S[MAX];

void insertSymbol(char *s)
{
	int i;
	for(i=0;i<sIndex;i++)
	{
		if(!strcmp(S[i].name,s))
		{
			printf("\nDuplicate Symbol %s at Line No : %d",s,line);
			return;
		}
	}
	strcpy(S[sIndex].name,s);
	strcpy(S[sIndex].type,"-1");
	sIndex++;
}

void setSymbolType(char *s)
{
	int i;
	for(i=0;i<sIndex;i++)
	{
		if(!strcmp(S[i].type,"-1"))
			strcpy(S[i].type,s);
	}
}

void checkSymbol(char *s)
{
	int i;
	for(i=0;i<sIndex;i++)
	{
		if(!strcmp(S[i].name,s))
			return;
	}
	printf("\nUndeclared Symbol %s at Line No : %d",s,line);
}

int getType(char *s)
{
	int i;
	for(i=0;i<sIndex;i++)
	{
		if(!strcmp(S[i].name,s))
		{
			if(!strcmp(S[i].type,"char"))
				return 1;
			else if(!strcmp(S[i].type,"int"))
				return 2;
			else if(!strcmp(S[i].type,"float"))
				return 3;
			else if(!strcmp(S[i].type,"double"))
				return 4;
		}
	}
	if(strstr(s,"."))
		return 3;	//NUM of type float
	else
		return 2;	//NUM of type int
}

char *fetchType(int x)
{
	if(x==1)
		return "char";
	else if(x==2)
		return "int";
	else if(x==3)
		return "float";
	else if(x==4)
		return "double";
}

void displaySymtab()
{
	int i;
	printf("\n\n***SYMBOL TABLE***\n");
	for(i=0;i<sIndex;i++)
		printf("\nVARIABLE - %s \t TYPE - %s",S[i].name,S[i].type);
}

#undef MAX
