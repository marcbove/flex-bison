%{
	#include <stdio.h> 
	#include <stdlib.h> 

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

lsimbolos : SIMB lsimbolos {}
          | NUM lsimbolos {}
          | SIMB ;

estados : ESTADOS '{' NUM '}';

transiciones: TRANSICIONES '{' ltransicion '}';

ltransicion : TRANS ltransicion {}
			| TRANS;

inicial : INICIAL '{' NUM '}';

finales : FINALES lfinales {};

lfinales : NUM lfinales {}
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
    	char * fileName = argv[1];
        if (!(yyin = fopen(fileName, "r"))) /* if the file cannot be opened*/
        {
            printf("Hi ha hagut un error en el fitxer.");
            return 1; /* Return error code */ 
        }
    }
    do { 
		yyparse();
	} while(!feof(yyin));
	
	printf("\nEl programa ha finalitzat correctament!\n");

	return 0;
}