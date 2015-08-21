#include <Stdio.h>
#include <string.h>

typedef struct TNode Node;

typedef struct TNode {
    char a;
    Node *p;
};


int check(char str[])
{
    int i=0;
    Node *que,*t;
    que->a='0';
    que->p=NULL;
    while(str[i] != '\0')
    {
        if ((str[i] == '(') || (str[i] == '[') || (str[i] == '{'))
        {
            t = (Node *) malloc(sizeof(Node));
            t->a = str[i];
            t->p = que;
            que->a = str[i];
            i++;
            continue;
        }
        if ( ((str[i] == ')') && (que->a == '(') ) || ((str[i] == ']') && (que->a == '[') ) ||((str[i] == '}') && (que->a == '{') ))
        {
            que = que->p;
            i++;
            continue;    
        }
        return 0;
    }
    return 1;
}

char *run(char ret[], char str[])
{
    if (check(str) == 1)
        ret[strlen(ret)] = 1;
    else ret[strlen(ret)] = 0;
    return ret;
}

int main()
{
    int i,ti;
    char str[128],ret[128];
    scanf("%i",&ti);
    for (i=0;i<ti;i++)
    {  
        scanf("%s",str);
        ret  = run(ret,str);
    }
    printf("%s",ret);
}
