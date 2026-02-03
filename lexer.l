%{
    #include <stdio.h>
    #include "y.tab.h"
%}


%%

0|(-)?[1-9][0-9]*(\.[0-9]*[1-9])?      { yylval.valFloat = atof(yytext); return NUMBER; }
simx                            return SIMX;
simy                            return SIMY;
sim0                            return SIM0;
isOpen                          return ISOPEN;
Close                           return CLOSE;
[a-zA-Z][a-zA-z0-9]*            {yylval.string = strdup(yytext); strncpy(yylval.string,yytext,yyleng); return STRING;}
\=                              return EQ;
\+                              return PLUS;
\(                              return LPAR;
\)                              return RPAR;
\n                              return EOL;
[\t ]
.
