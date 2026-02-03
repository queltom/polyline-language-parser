all: elaborato elaboratoPLus	

elaborato: lexer.l parser.y
	lex lexer.l
	yacc -d parser.y
	gcc y.tab.c lex.yy.c -o elaborato -lm

elaboratoPLus: lexer.l parserPlus.y
	lex lexer.l
	yacc -d parserPlus.y
	gcc y.tab.c lex.yy.c -o elaboratoPLus -lm
    
clean: 
	rm -rf y.tab.c y.tab.h lex.yy.c elaborato elaboratoPLus
