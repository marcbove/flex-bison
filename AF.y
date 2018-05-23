%{
	#include <stdio.h> 
	#include <stdlib.h> 
	#include <string.h>

	extern int yylex();
	extern int yyparse();
	extern FILE* yyin;
	void yyerror(const char* s); 
	extern char *yytext;
%}

%token ALFABETO ESTADOS TRANSICIONES INICIAL FINALES
%token TRANS NUM SIMB COMENT ERROR

%%
af : alfabeto estados transiciones inicial finales ;

alfabeto: ALFABETO '{' lsimbolos '}';

lsimbolos : SIMB lsimbolos
          | NUM lsimbolos
          | SIMB ;

estados : ESTADOS '{' NUM '}';

transiciones: TRANSICIONES '{' ltransicion '}';

ltransicion : TRANS ltransicion
			| TRANS;

inicial : INICIAL '{' NUM '}';

finales : FINALES '{' lfinales '}';

lfinales : NUM lfinales
		 | NUM ;

%%
void yyerror(const char* s) 
{
	fprintf(stderr, "Error: %s\n", s);
	exit(1);
}

int main(int argc, char *argv)
{
	if (argc > 1) /* if there is at least 1 argument apart from program name */
    {
    	yyin = fopen(argv[1], "r");
        if (yyin == NULL) /* if the file cannot be opened*/
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