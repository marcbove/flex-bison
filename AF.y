%{
	#include <stdio.h> 
	#include <stdlib.h> 
	#include <string.h>

	extern int yylex(void);
	extern int yyparse();
	extern char *yytext;
	extern FILE *yyin;

	void yyerror(char* s); 
%}

%union 
{
	char* car;
}

%token ALFABETO ESTADOS TRANSICIONES INICIAL FINALES
%token TRANS <car>NUM <car>SIMB COMENT ERROR

%%
af : alfabeto estados transiciones inicial finales ;

alfabeto: ALFABETO '{' lsimbolos '}';

lsimbolos : SIMB ',' lsimbolos
          | NUM ',' lsimbolos
          | SIMB ;

estados : ESTADOS '{' NUM '}';

transiciones: TRANSICIONES '{' ltransicion '}';

ltransicion : TRANS ',' ltransicion
			| TRANS;

inicial : INICIAL '{' NUM '}';

finales : FINALES '{' lfinales '}';

lfinales : NUM ',' lfinales
		 | NUM ;

%%
void yyerror(char* s) 
{
	fprintf(stderr, "Error: %s\n", s);
	exit(1);
}

void transicion() 
{
	//int i;
	for (int i = 0; i<numtra; i++)
	{
		if (esDeterminista) 
		{
			if(i == 0)
				printf("\nint transicion(int estado, char simbolo) {\n\tint sig;");
			
			printf("\n\tif((estado==%d)&&(simbolo=='%s')) sig = %d;", atoi(transiciones[i][0]), transiciones[i][1], atoi(transiciones[i][2]));
			
			if(i == numtra-1)
				printf("\n\treturn(sig);\n}\n");
		}
		else 
		{
			if(i == 0)
				printf("\nint* transicion(int estado, char simbolo) {\n\tstatic int sig[num-estados+1], n=0;");
			
			printf("\n\tif((estado==%d)&&(simbolo=='%s')) sig[n++] = %d;", atoi(transiciones[i][0]), transiciones[i][1], atoi(transiciones[i][2]));
			
			if(i == numtra-1)
				printf("\n\tsig[n]=-1; /* centinella */\n\treturn(sig);\n}\n");
		}
	} 
}

int main(int argc, char **argv)
{
	//FILE* yyin;
	if (argc > 1) /* if there is at least 1 argument apart from program name */
    {
    	yyin = fopen(argv[1], "rt");
        
        if (yyin == NULL) /* if the file cannot be opened */ 
        {
            printf("Hi ha hagut un error en el fitxer.\n");
            return 1; /* Return error code */ 
        }
    }
    yyparse();
	printf("\nEl programa ha finalitzat correctament!\n");
	fclose(yyin);
	return 0;
}