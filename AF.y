/*
	Authors :  Bové Gómara, Marc
			   López Mellina, Alex
			   Mege Barriola, Gwen
*/
%define parse.error verbose
%{
	#include <stdio.h>
	#include <stdlib.h>
	#include <string.h>		
	#include <stdbool.h>

	#define MAX_VALUE 32
	
	extern int yylex(void);
	extern char *yytext;
	FILE *yyin;
	extern int num_lines, num_states;
	
	void yyerror(char *s);
	void simbRepeated(char *simb);
	void comprTransicion(char *estatInici, char *simb, char *estatFinal);

	int num_simbols = 0, num_trans = 0;
	char *transi[MAX_VALUE][3], *alf[MAX_VALUE];
%}

%union 
{
	char *car;
}

%token ALFABETO ESTADOS TRANSICIONES INICIAL FINALES
%token TRANS <car>SIMB COMENT ERROR 
%token ABRIR CERRAR COMA PAR_A PUNTOCOMA PAR_C

%%
af : alfabeto estados transiciones inicial finales ;

alfabeto: ALFABETO ABRIR lsimbolos CERRAR ;

lsimbolos : 						{ printf("[ERROR]: El alfabeto debe contener uno o más símbolos\n"); } /* (2) */
		  | SIMB COMA lsimbolos 	{ simbRepeated($1); }
          | SIMB					{ simbRepeated($1); };

estados : ESTADOS ABRIR SIMB CERRAR;

transiciones: TRANSICIONES ABRIR ltransicion CERRAR;

ltransicion : trans COMA ltransicion
			| trans;

trans: PAR_A SIMB COMA SIMB PUNTOCOMA SIMB PAR_C  { comprTransicion($2, $4, $6);};

inicial : INICIAL ABRIR linicial CERRAR;

linicial : 						{ printf("[ERROR]: Los Autómatas Finitos solo deben tener un estado final\n"); } /* (3) */
		 | SIMB COMA linicial 	{ printf("[ERROR]: Los Autómatas Finitos solo deben tener un estado final\n"); } /* (3) */
         | SIMB;

finales : FINALES ABRIR lfinales CERRAR;

lfinales : 						{ printf("[ERROR]: Los Autómatas Finitos deben tener algún estado final\n"); } /* (4) */
		 | SIMB COMA lfinales
		 | SIMB ;

%%
void yyerror(char *s) 
{
	fprintf(stderr, "%d: Error: %s\n", num_lines, s);
	exit(1);
}

void simbRepeated(char *simb)
{	
	int i = 0, trobat = 0;
	while (i < num_simbols && trobat == 0) 
	{
		if (strcmp(alf[i], simb) == 0)
			trobat = 1;
		else 
			i++; 
	}
	if (trobat == 0) 
		alf[num_simbols++] = simb;
	else 
		printf("[AVISO]: EL símbolo %s ya existe\n", simb); /* (6) */
}

bool esDeterminista()
{
	int i=0, j=0;
	for (int i = 0; i<num_trans; i++)
		for (int j = i+1; j < num_trans; j++)
			if ((strcmp(transi[j][0], transi[i][0]) == 0) && (strcmp(transi[j][1], transi[i][1]) == 0)) 
				return false;
	return true;
}

void comprTransicion(char* estatI, char* simb, char* estatF)
{
	int i=0; 
	int trobat=false;
	int estatInici = atoi(estatI);
	int estatFinal = atoi(estatF);

	if((estatInici > num_states) || (estatFinal > num_states)) 
		printf("[ERROR]: El estado %d de la transición (%d , %s ; %d) es desconocido\n", 
			estatInici, estatInici, simb, estatFinal); /* (5) */
	
	while (i<num_simbols && !trobat) 
	{
		if (strcmp(alf[i], simb) ==0 ) 
			trobat = true;
		else 
			i++;
	}
	if (!trobat) 
		printf ("[ERROR]: El simbolo %s de la transición (%d , %s ; %d) es desconocido\n", 
			simb, estatInici, simb, estatFinal); /* (5) */

	if (trobat && estatInici<=num_states && estatFinal<=num_states) 
	{
		i=0; 
		int trobat2=false;
		while (i<num_trans && !trobat2) 
		{
			if ((strcmp(transi[i][0], estatI) == 0) && (strcmp(transi[i][1], simb) == 0) && (strcmp(transi[i][2], estatF) == 0)) 
				trobat2=true;
			else  
				i++;
		}
		if (!trobat2) 
		{ 
			transi[num_trans][0]=estatI; 
			transi[num_trans][1]=simb; 
			transi[num_trans][2]=estatF; 
			num_trans++; 
		}
		//else 
			//printf("[AVISO]: La transición (%d , %s ; %d) ya existe\n", estatInici, simb, estatFinal);
	}
}

void transicion() /* (1) */
{
	for (int i = 0; i<num_trans; i++)
	{
		if (esDeterminista()) 
		{
			if(i == 0)
				printf("\nint transicion(int estado, char simbolo) {\n\tint sig;");
			
			printf("\n\tif((estado==%d)&&(simbolo=='%s')) sig = %d;", atoi(transi[i][0]), transi[i][1], atoi(transi[i][2]));
			
			if(i == num_trans-1)
				printf("\n\treturn(sig);\n}\n");
		}
		else 
		{
			if(i == 0)
			{
				printf("[AVISO]: Se ha detectado que el AF es no determinista\n"); /* (7) */
				printf("\nint * transicion(int estado, char simbolo) {\n\tstatic int sig[num-estados+1], n=0;");
			}
			printf("\n\tif((estado==%d)&&(simbolo=='%s')) sig[n++] = %d;", atoi(transi[i][0]), transi[i][1], atoi(transi[i][2]));
			
			if(i == num_trans-1)
				printf("\n\tsig[n]=-1; /* centinella */\n\treturn(sig);\n}\n");
		}
	} 
}

int main(int argc, char **argv)
{
	if (argc > 1) /* if there is at least 1 argument apart from program name */
    {
    	yyin = fopen(argv[1], "rt");
        
    	if (yyin == NULL) /* if the file cannot be opened */ 
        {
        	printf("[ERROR]: Ha habido algún error en el fichero\n");
            return 1; /* Return error code */ 
        }
    }
    else
    	yyin = stdin;

    yyparse();
    //if(!esDeterminista())
    //	printf("[AVISO]: Se ha detectado que el AF es no determinista\n"); /* (7) */
    transicion();
	printf("\nEl programa ha finalizado correctamente!\n");
	fclose(yyin);
	return 0; /* Return succeed code */
}