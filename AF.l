/*
	Authors :  Bové Gómara, Marc
			   López Mellina, Alex
			   Mege Barriola, Gwen
*/
%option caseless
%option noyywrap
%{
	#include <stdbool.h> /* lib for booleans in C/C++ */
    #include <ctype.h>
    #include "AF.tab.h"
    
    bool is_state = false, is_inicial = false, is_final = false;
    int num_states = 0, num_lines = 1;
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
alfabeto        { return(ALFABETO); }

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
					if(is_state)
					{	
						is_state = false;
						num_states = atoi(yytext); /* store the value indicating the number of states */
					}
					yylval.car = strdup(yytext);
                    return(SIMB);
				}

{SIMBOLO}       { 
                    if(is_inicial||is_state||is_final)
                    {
                    	if(!atoi(yytext))
	                    {
	                        if(is_inicial)
	                           	printf("[ERROR]: Inicial no puede tener simbolos\n");
	                        if(is_state)
	                           	printf("[ERROR]: Estados no puede tener simbolos\n");
	                        if(is_final)
	                        	printf("[ERROR]: Finales no puede tener simbolos\n");
                    	}
                    }
                    else
                    	yylval.car = strdup(yytext);
                        return(SIMB);                
                }

{TRANSICION}    { /*return(TRANS);*/ }

{COMENTARIO}    { /*printf("%s", yytext); return(COMENT);*/ }

{SEP}           { }

{ABRIR}			{ return(ABRIR);}	

{CERRAR}		{ 	
					is_final = false;
					is_state = false; 
					is_inicial = false;
					return(CERRAR);
				}

{COMA}			{ return(COMA);}		

{PAR_C}			{ return(PAR_C);}		

{PAR_A}			{ return(PAR_A);}		

{PUNTOCOMA}		{ return(PUNTOCOMA);}		

{ENTER} 		{ num_lines++; }

<<EOF>>         { yyterminate(); }

%%