%{
    #include <stdio.h>
    #include <stdlib.h>
    #include <string.h>
    #include <stdbool.h>
    #include <math.h>

    void yyerror(const char *s);
    int yylex();
    int yywrap();

    int globalSpacing = 0;

    // Definizione della struttura del nodo
typedef struct Nodo {
    char valore[1000];
    bool printable;
    struct Nodo** figli;
    int num_figli;
    int profondita;  // Campo per la profondità del nodo
} Nodo;

// Funzione per creare un nuovo nodo
Nodo* crea_nodo(const char* valore, int profondita, bool printable) {
    Nodo* nuovo_nodo = (Nodo*)malloc(sizeof(Nodo));
    if (!nuovo_nodo) {
        fprintf(stderr, "Errore allocazione memoria\n");
        exit(EXIT_FAILURE);
    }
    strcpy(nuovo_nodo->valore, valore);
    nuovo_nodo->num_figli = 0;
    nuovo_nodo->printable = printable;
    nuovo_nodo->figli = NULL; // Inizialmente senza figli
    nuovo_nodo->profondita = profondita;  // Imposta la profondità del nodo
    return nuovo_nodo;
}

// Funzione per aggiungere un figlio a un nodo
void aggiungi_figlio(Nodo* genitore, Nodo* figlio) {
    genitore->figli = (Nodo**)realloc(genitore->figli, (genitore->num_figli + 1) * sizeof(Nodo*));
    genitore->figli[genitore->num_figli++] = figlio;
}

// Funzione per inserire un nodo figlio sotto un nodo padre specificato
void inserisci_figlio(Nodo* genitore, Nodo* figlio) {
    if (genitore != NULL) {
        //figlio->profondita = genitore->profondita;  // Aggiorna la profondità del nodo figlio
        aggiungi_figlio(genitore, figlio);
    } else {
        printf("Nodo genitore non valido.\n");
        free(figlio);
    }
}

// Funzione per stampare l'albero in pre-ordine con spaziatura basata sulla profondità
void stampa_pre_ordine(Nodo* nodo) {
    if (nodo == NULL) return;
    for (int i = 0; i < (nodo->profondita)*10; ++i) {
        printf("-");
    }
    if (nodo->printable) printf("%s\n",nodo->valore);
    for (int i = 0; i < nodo->num_figli; ++i) {
        stampa_pre_ordine(nodo->figli[i]);
    }
}

// Funzione per liberare la memoria dell'albero
void libera_nodo(Nodo* nodo) {
    if (nodo == NULL) return;
    for (int i = 0; i < nodo->num_figli; ++i) {
        libera_nodo(nodo->figli[i]);
    }
    free(nodo->figli);
    free(nodo);
}
%}

%union {
    struct Nodo* node;
    float valFloat;
    char* string;
}

%token SIMX SIMY SIM0 ISOPEN PLUS LPAR CLOSE RPAR EQ EOL 
%token <valFloat> NUMBER
%token <string> STRING 
%type <node> polyline def def69 point
%%

line : 
     | line polyline EOL            { stampa_pre_ordine($2); }
     ;

polyline: STRING EQ CLOSE STRING                {Nodo* radice = crea_nodo("RADICE", 0, false);
                                                 Nodo* nodo_a = crea_nodo($1, 0, true);
                                                 inserisci_figlio(radice,nodo_a);
                                                 Nodo* nodo_b = crea_nodo("=", 0, true);
                                                 inserisci_figlio(radice,nodo_b);
                                                 Nodo* nodo_c = crea_nodo("Close", 1, true);
                                                 inserisci_figlio(radice,nodo_c);
                                                 Nodo* nodo_d = crea_nodo($4, 2, true);
                                                 inserisci_figlio(radice,nodo_d);
                                                 $$ = radice;} 
        | STRING EQ STRING                      {Nodo* radice = crea_nodo("RADICE", 0, false);
                                                 Nodo* nodo_a = crea_nodo($1, 0, true);
                                                 inserisci_figlio(radice,nodo_a);
                                                 Nodo* nodo_b = crea_nodo("=", 0, true);
                                                 inserisci_figlio(radice,nodo_b);
                                                 Nodo* nodo_c = crea_nodo($3, 1, true);
                                                 inserisci_figlio(radice,nodo_c);
                                                 $$ = radice;}
        | STRING EQ STRING PLUS STRING          {Nodo* radice = crea_nodo("RADICE", 0, false);
                                                 Nodo* nodo_a = crea_nodo($1, 0, true);
                                                 inserisci_figlio(radice,nodo_a);
                                                 Nodo* nodo_b = crea_nodo("=", 0, true);
                                                 inserisci_figlio(radice,nodo_b);
                                                 Nodo* nodo_d = crea_nodo("+", 1, true);
                                                 inserisci_figlio(radice,nodo_d);
                                                 Nodo* nodo_c = crea_nodo($3, 2, true);
                                                 inserisci_figlio(radice,nodo_c);
                                                 Nodo* nodo_e = crea_nodo($5, 2, true);
                                                 inserisci_figlio(radice,nodo_e);
                                                 $$ = radice;}
        | STRING EQ {globalSpacing+=1;} def {globalSpacing-=1;} {Nodo* radice = crea_nodo("RADICE", 0, false);
                                                 Nodo* nodo_a = crea_nodo($1, 0, true);
                                                 inserisci_figlio(radice,nodo_a);
                                                 Nodo* nodo_b = crea_nodo("=", 0, true);
                                                 inserisci_figlio(radice,nodo_b);
                                                 inserisci_figlio(radice,$4);
                                                 $$ = radice;} 
        | CLOSE {globalSpacing+=1;} def {globalSpacing-=1;}  {Nodo* radice = crea_nodo("RADICE", 0, false);
                                                 Nodo* nodo_a = crea_nodo("Close", 0, true);
                                                 inserisci_figlio(radice,nodo_a);
                                                 inserisci_figlio(radice,$3);
                                                 $$ = radice;}
        | ISOPEN {globalSpacing+=1;} def {globalSpacing-=1;} {Nodo* radice = crea_nodo("RADICE", 0, false);
                                                 Nodo* nodo_a = crea_nodo("isOpen", 0, true);
                                                 inserisci_figlio(radice,nodo_a);
                                                 inserisci_figlio(radice,$3);
                                                 $$ = radice;}
        | ISOPEN STRING                         {Nodo* radice = crea_nodo("RADICE", 0, false);
                                                 Nodo* nodo_a = crea_nodo("isOpen", 0, true);
                                                 inserisci_figlio(radice,nodo_a);
                                                 Nodo* nodo_b = crea_nodo($2, 1, true);
                                                 inserisci_figlio(radice,nodo_b);
                                                 $$ = radice;}
        | CLOSE STRING                          {Nodo* radice = crea_nodo("RADICE", 0, false);
                                                 Nodo* nodo_a = crea_nodo("Close", 0, true);
                                                 inserisci_figlio(radice,nodo_a);
                                                 Nodo* nodo_b = crea_nodo($2, 1, true);
                                                 inserisci_figlio(radice,nodo_b);
                                                 $$ = radice;} 
        | def                                   {$$ = $1;}
        | STRING                                {Nodo* radice = crea_nodo("RADICE", 0, false);
                                                 Nodo* nodo_a = crea_nodo($1, 0, true);
                                                 inserisci_figlio(radice,nodo_a);
                                                 $$ = radice;}
        ;

def: SIMX {globalSpacing+=1;} LPAR  def RPAR  {globalSpacing-=1;} def69     {Nodo* radice = crea_nodo("RADICE", 0, false);
                                                                                Nodo* nodo_a = crea_nodo("simx", 0+globalSpacing, true);
                                                                                inserisci_figlio(radice,nodo_a);
                                                                                inserisci_figlio(radice,$4);
                                                                                if($7) inserisci_figlio(radice,$7);
                                                                                $$ = radice;}
   | SIMY {globalSpacing+=1;} LPAR def RPAR {globalSpacing-=1;} def69     {Nodo* radice = crea_nodo("RADICE", 0, false);
                                                                                Nodo* nodo_a = crea_nodo("simy", 0+globalSpacing, true);
                                                                                inserisci_figlio(radice,nodo_a);
                                                                                inserisci_figlio(radice,$4);
                                                                                if($7) inserisci_figlio(radice,$7);
                                                                                $$ = radice;}
   | SIM0 {globalSpacing+=1;} LPAR def RPAR {globalSpacing-=1;}  def69     {  Nodo* radice = crea_nodo("RADICE", 0, false);
                                                                                Nodo* nodo_a = crea_nodo("sim0", 0+globalSpacing, true);
                                                                                inserisci_figlio(radice,nodo_a);
                                                                                inserisci_figlio(radice,$4);
                                                                                if($7) inserisci_figlio(radice,$7);
                                                                                $$ = radice;}
   | point def                      {inserisci_figlio($1,$2);$$ = $1;}
   | point                          {$$ = $1;}
   ;

def69: def                          {$$ = $1;}
    |                               {$$ = NULL;}
    ;

point: NUMBER NUMBER              { 
                                    char buffer[100];
                                    Nodo* radice = crea_nodo("RADICE", 0, false);
                                    sprintf(buffer,"%.2f", $1);
                                    Nodo* nodo_a = crea_nodo(buffer, 0+globalSpacing, true);
                                    sprintf(buffer,"%.2f", $2);
                                    Nodo* nodo_b = crea_nodo(buffer, 0+globalSpacing, true);
                                    inserisci_figlio(radice,nodo_a);
                                    inserisci_figlio(radice,nodo_b);
                                    $$ = radice;
                                    }
    ;


//assumo che il punto e virgola alla fine non sia necessario
%%



int yywrap() {
    return -1;
}

void yyerror(const char *s) {
    fprintf(stderr, "%s\n", s);
}

int main(char argc, char **argv) {
     yyparse();
}

