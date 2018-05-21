%{
	#include <stdio.h> 
	#include <stdlib.h> 
	#include <string.h> 


	extern int yylex(void); 
	extern char *yytext;
	extern FILE *yyin; 
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

int main(int argc, char *argv)
{
	if (argc > 1) /* if there is at least 1 argument apart from program name */
    {
        if (!(yyin = fopen(argv[1], "r"))) /* if the file cannot be opened*/
        {
            perror(argv[1]);
            return 1; /* Return error code */ 
        }
    }
	yyparse();
	printf("\n\nSEPA ha acabat... la lectura ha sigut un exit\n");

	return 0;
}