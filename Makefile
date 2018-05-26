all: AF

AF.tab.c AF.tab.h:	AF.y
	bison -d AF.y

lex.yy.c: AF.l AF.tab.h
	flex AF.l

AF: lex.yy.c AF.tab.c AF.tab.h
	gcc -o AF AF.tab.c lex.yy.c

clean:
	rm AF AF.tab.c lex.yy.c AF.tab.h transicion.c transicion.h