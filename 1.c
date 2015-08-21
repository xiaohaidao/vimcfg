#include <Stdio.h>
#include <stdlib.h>
#include <string.h>

typedef struct TNode Node;

typedef struct TNode {
    char a;
    Node *p;
} Node;


int check(char str[])
{
    int i=0;
    Node *que,*t;
    que->a = 'o';
    que->p=NULL;
    while(str[i] != '\0')
    {
        if ((str[i] == '(') || (str[i] == '[') || (str[i] == '{'))
        {
            t = (Node *) malloc(sizeof(Node));
            t->a = str[i];
            t->p = que;
            que = t;
            i++;
            continue;
        }
        if ( 
                ((str[i] == ')') && (que->a == '(') )
                ||((str[i] == ']') && (que->a == '[') ) 
                ||((str[i] == '}') && (que->a == '{') )
           )
        {
            que = que->p;
            i++;
            continue;    
        }
        return 0;
    }
    if (que->a == 'o')
        return 1;
    return 0;
}

Node run(Node ret, char str[])
{
    Node *tret;
    Node *tret1 = (Node *)malloc (sizeof(Node));
    tret1->p = NULL;
    tret1->a = 'o';
    tret = &ret;
    while (tret->p!= NULL)
        tret = tret->p;
    if (check(str) == 1)
    {
        tret->a = 'y';
    }
    else 
    {             
        tret->a = 'n';
    }
    tret->p =  tret1;
    return ret;
}

int main()
{
    int i,ti;
    char str[128];
    Node ret;
    ret.p = NULL;
    ret.a = 'o';
    scanf("%i",&ti);
    for (i=0;i<ti;i++)
    {  
        scanf("%s",str);
        ret  = run(ret,str);
    }
    while (ret.p != NULL)
    {
        if (ret.a == 'y')
            printf("Yes!\n");
        if (ret.a == 'n')
            printf("No!\n");
       ret = *(ret.p);
    }
}
