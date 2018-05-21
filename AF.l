/*
	Authors :  Bové Gómara, Marc
			   López Mellina, Alex
			   Mege Barriola, Gwen
*/
%option caseless
%option noyywrap
%{
	#include <stdbool.h> /* lib for booleans in C/C++ */
    #include "AF.tab.h"
    bool is_state = false, is_inicial = false, is_final = false;
    int num_states = 0;
%}
NUM				0|[1-9][0-9]+
SEP 			[ \t\r]*
ENTER			\n
SIMBOLO			[0-9|a-z|A-Z]+
ABRIR			"{"
CERRAR			"}"
COMA			","
PUNTOCOMA		";"
PAR_A			"("
PAR_C			")"
TRANSICION		{SEP}{PAR_A}{SEP}{NUM}{SEP}{COMA}{SEP}{SIMBOLO}{SEP}{PUNTOCOMA}{SEP}{NUM}{SEP}{PAR_C}{SEP}
COMENTARIO		"%".*{ENTER}

%%
alfabeto        {   return ALFABETO;}

estados			{ 
					is_state = true;
					return(ESTADOS);
				}
transiciones	{   return(TRANSICIONES);}

inicial			{ 
                    is_inicial = true;
                    return(INICIAL);
                }
finales			{ 
                    is_final = true;
                    return(FINALES);
                }
{NUM}    		{ 
                    if(is_inicial)
                    {
                        is_inicial = false;
                    }
					if(is_state)
					{	
						is_state = false;
						num_states = atoi(yytext); /* store the value indicating the number of states */
					}
                    return(NUM);
				}

{SIMBOLO}       { 
                    if(is_inicial||is_state||is_final)
                    {
                        return(ERROR);
                        if(is_inicial)
                            is_inicial = false;
                        if(is_state)
                            is_state = false;
                    }
                    else
                        return(SIMB);                
                }

{TRANSICION}    { return(TRANS); }

{COMENTARIO}    { return(COMENT); }
{SEP}           { }

<<EOF>>         { yyterminate(); }

%%
int main(int argc, char*argv[])
{ 
    if (argc > 1) /* if there is at least 1 argument apart from program name */
    {
        if (!(yyin = fopen(argv[1], "r"))) /* if the file cannot be opened*/
        {
            perror(argv[1]);
            return 1; /* Return error code */ 
        }
    }
    yylex();
    printf("Number of States = %d\n", num_states); /* Print the number of states */
    return 0;
}
