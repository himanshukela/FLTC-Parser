#define MAX 50

extern int iIndex;

struct quad
{
	int no;
	char _operator[10];
	char op1[10];
	char op2[10];
	char result[10];
	
}Q[MAX];

void insert_instr(char *Operator,char *Op1,char *Op2,char *Result)
{
	Q[iIndex].no = iIndex;
	strcpy(Q[iIndex]._operator,Operator);
	strcpy(Q[iIndex].op1,Op1);
	strcpy(Q[iIndex].op2,Op2);
	strcpy(Q[iIndex].result,Result);
	
	iIndex++;
}

void insert_goto(int position,int goto_loc)
{
	char temp[10],t[5];
	strcpy(temp,"GOTO-");
	sprintf(t,"%d",goto_loc);
	strcat(temp,t);
	
	strcpy(Q[position].result,temp);
}

void displayQuad()
{
	int i;
	printf("\n\nADDR\t  OPERATOR\tOP1\t   OP2\t\tRESULT\n");
	for(i=1;i<iIndex;i++)
		printf("\n%04d %10s %10s %10s %15s",Q[i].no,Q[i]._operator,Q[i].op1,Q[i].op2,Q[i].result);
	printf("\n\n");
}

void writeQuad()
{
	int i;
	FILE *fp;
	fp = fopen("quad","w");
	
	if(fp==NULL)
	{
		printf("\nFile not created !\n");
		return -1;
	}
	for(i=1;i<iIndex;i++)
	{
		fprintf(fp,"\n%04d %10s %10s %10s %15s",Q[i].no,Q[i]._operator,Q[i].op1,Q[i].op2,Q[i].result);
	}
}

#undef MAX
