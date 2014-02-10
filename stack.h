#define MAX 20

struct stack
{
	char data[MAX][10];
	int top;
};

void init(struct stack *s)
{
	s->top = -1;
}

char *pop(struct stack *s)
{
	char *x;
	x = strdup(s->data[s->top]);
	s->top=s->top-1;
	return x;
}

void push(struct stack *s,char *x)
{
	s->top=s->top+1;
	strcpy(s->data[s->top],x);
}

char *top(struct stack *s)
{
	return strdup(s->data[s->top]);
}

//****//

struct stack1
{
	int data[MAX];
	int top;
};

void init1(struct stack1 *q)
{
	q->top = -1;
}

int pop1(struct stack1 *q)
{
	int x;
	x = q->data[q->top];
	q->top=q->top-1;
	return x;
}

void push1(struct stack1 *q,int x)
{
	q->top=q->top+1;
	q->data[q->top] = x;
}

#undef MAX
