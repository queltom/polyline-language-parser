%{
    #include <stdio.h>
    #include <stdlib.h>
    #include <string.h>
    #include <stdbool.h>
    #include <math.h>

    void yyerror(const char *s);
    int yylex();
    int yywrap();

    typedef union{
        int numberInt;
        float numberFloat;
    }dot;

    typedef struct dotCoordinate{
        float x;
        float y;
    }point;

    typedef struct polilinea{
        int numPoints;
        char name[200];
        point coordinates[1000];
    }polyline;

    point coordinatesTemp[1000];
    int counterCoordinatesTemp = 0;
    int counterGlobalArray = 0;
    polyline globalArray[1000];
    bool xFlag = false;
    bool yFlag = false;
    bool polyName = false;

    int numLinee = 0;

    double pow(double base, double exponent) {
        // Handle the case when the exponent is 0
        if (exponent == 0) {
            return 1;
        }

        // Handle the case when the exponent is negative
        int isNegative = 0;
        if (exponent < 0) {
            isNegative = 1;
            exponent = -exponent;
        }

        double result = 1;
        while (exponent > 0) {
            result *= base;
            exponent--;
        }

        // If the exponent was negative, take the reciprocal of the result
        if (isNegative) {
            return 1 / result;
        }

        return result;
    }

    // Function to compute the square root of a number using the Newton-Raphson method
    double sqrt(double number) {
        if (number < 0) {
            printf("Negative input error.\n");
            return -1; // Return an error value for negative input
        }

        double tolerance = 0.000001; // Define the tolerance level
        double guess = number / 2.0; // Initial guess

        // Iteratively improve the guess
        while (1) {
            double nextGuess = 0.5 * (guess + number / guess);
            if (fabs(nextGuess - guess) < tolerance) {
                return nextGuess; // Return the guess when within tolerance
            }
            guess = nextGuess;
        }
    }


    void push(float x, float y){
        if(xFlag) x*=-1;
        if(yFlag) y*=-1;
        point puntoTemp = {x,y};
        if(polyName == false){ //se devo pushare un punto che non fa parte di una polilinea con nome
            coordinatesTemp[counterCoordinatesTemp] = puntoTemp;
        }
        else{
            //TO DO: assegnamento punto di una polilinea con nome
            coordinatesTemp[counterCoordinatesTemp] = puntoTemp;
        }
       
    }

    void printTempPointStats(){
        float somma = 0;
        for(int i = 0;i<counterCoordinatesTemp-1;i++){
            //printf("punto(%f,%f)\n",coordinatesTemp[i].x,coordinatesTemp[i].y);
            //printf("intermedio x: %f\n",pow((coordinatesTemp[i+1].x-coordinatesTemp[i].x),2));
            somma+= sqrt(pow((coordinatesTemp[i+1].x-coordinatesTemp[i].x),2)+pow((coordinatesTemp[i+1].y-coordinatesTemp[i].y),2));
            //printf("%f\n",somma);
        }
        //printf("punto(%f,%f)\n",coordinatesTemp[2].x,coordinatesTemp[2].y);
        //simx(1 2 sim0(3 4)) 5 6
        printf("Lughezza: %.3f cm\n",somma);
    }


    void printisOpenTempPoint(){
        if(counterCoordinatesTemp!=1 || (coordinatesTemp[0].x!=coordinatesTemp[counterCoordinatesTemp-1].x || coordinatesTemp[0].y!=coordinatesTemp[counterCoordinatesTemp-1].y))
        {printf("True\n");}
        else
        {printf("False\n");}
    }

    void printisOpenPolyLine(char* name){
        bool exit = false;
        for(int i=0;i<counterGlobalArray && !exit;i++){
            //printf("in pos:%d %s, len name: %d and len poly: %d\n",i,globalArray[i].name,strlen(name),strlen(globalArray[i].name));
            //printf("in pos:%d %s con punti: %d\n",i,globalArray[i].name,globalArray[i].numPoints);
            //printf("%s == %s -> %d\n",globalArray[i].name,name,!strncmp(globalArray[i].name,name,(strlen(name))));
            if(!strncmp(globalArray[i].name,name,(strlen(name)))){ //TO DO:  ATTENZIONE, NAME HA CARATTERE TERMINATORE IN PIU
                
                //printf("poly:%s, totPunti:%d puntoStart(%f,%f), puntoEnd(%f,%f)\n",globalArray[i].name,globalArray[i].numPoints,globalArray[i].coordinates[0].x,globalArray[i].coordinates[0].y,globalArray[i].coordinates[globalArray[i].numPoints-1].x,globalArray[i].coordinates[globalArray[i].numPoints-1].y);

                //globalArray[i].numPoints += 1;
                if(globalArray[i].numPoints!=1 && (globalArray[i].coordinates[0].x!=globalArray[i].coordinates[globalArray[i].numPoints-1].x || globalArray[i].coordinates[0].y!=globalArray[i].coordinates[globalArray[i].numPoints-1].y))
                    printf("True\n");
                else
                    printf("False\n");
                exit = true;
            } 
            
        }
    }

    //serve a terminare tutto se si sta allocando una polylinea che gia esiste
    int killProgram(char* name){
        for(int i=0;i<counterGlobalArray;i++){
            if(!strncmp(globalArray[i].name,name,(strlen(name)))){ //TO DO:  ATTENZIONE, NAME HA CARATTERE TERMINATORE IN PIU
                //printf("ERROR: poly already defined");
                //exit(1);
                return i;
            }
        }
        return counterGlobalArray;
    }

    //TO DO: chiarisci discorso arrotondamento -> prova esempio pdf
    void printisCloseTempPoint(){
        if(counterCoordinatesTemp!=1 || (coordinatesTemp[0].x!=coordinatesTemp[counterCoordinatesTemp-1].x || coordinatesTemp[0].y!=coordinatesTemp[counterCoordinatesTemp-1].y)){
            coordinatesTemp[counterCoordinatesTemp] = coordinatesTemp[0]; 
            counterCoordinatesTemp++;
            printTempPointStats();
        }
        else
            printf("Polyline already closed!\n");
    }

    void pushPolyline(char* name){
        int newPos = killProgram(name);
        //printf("%s\n",name);
        polyline tempPoly = {counterCoordinatesTemp};
        strcpy(tempPoly.name, name);
        globalArray[newPos] = tempPoly;
        
        //devo copiarmi a manina tutti i punti dentro alla poly
        for(int i=0;i<counterCoordinatesTemp;i++){
            globalArray[newPos].coordinates[i] = coordinatesTemp[i];
        }
        counterCoordinatesTemp = 0;
        //printf("%s\n",globalArray[counterGlobalArray].name);
        counterGlobalArray ++;

        /*
        for(int i=0;i<counterGlobalArray;i++){
            printf("in pos:%d %s con punti: %d\n",i,globalArray[i].name,globalArray[i].numPoints);
        }*/
    }

    void printPolyLineStat(char* name){
        bool exit = false;
        for(int i=0;i<counterGlobalArray && !exit;i++){
            //printf("in pos:%d %s, len name: %d and len poly: %d\n",i,globalArray[i].name,strlen(name),strlen(globalArray[i].name));
            //printf("%s\n",globalArray[i].name);
            if(!strncmp(globalArray[i].name,name,(strlen(name)))){ //TO DO:  ATTENZIONE, NAME HA CARATTERE TERMINATORE IN PIU
                //printf("MATCH in pos:%d %s\n",i,globalArray[i].name);
                //printf("ciao\n");
                float somma = 0;
                for(int j = 0;j<globalArray[i].numPoints-1;j++){
                    //printf("Punto %f %f \n",globalArray[i].coordinates[j].x,globalArray[i].coordinates[j].y);
                    //printf("POLY: %s, punto(%f,%f)\n",globalArray[i].name,globalArray[i].coordinates[j+1].x,globalArray[i].coordinates[j+1].y);
                    //printf("intermedio x: %f\n",pow((coordinatesTemp[i+1].x-coordinatesTemp[i].x),2));
                    somma+= sqrt(pow((globalArray[i].coordinates[j+1].x-globalArray[i].coordinates[j].x),2)+pow((globalArray[i].coordinates[j+1].y-globalArray[i].coordinates[j].y),2));
                    //printf("%f\n",somma);
                }
                
                //P1 = simx (1 2 sim0(3 4) ) 5 6
                //P2 = simx (1 2 sim0(3 4) ) 6 6
                printf("Lughezza: %.3f cm\n",somma);
                exit = true;

                //serve per stampare i punti della polililinea
                /*for(int j = 0;j<globalArray[i].numPoints;j++){
                    printf("POLY: %s, punto(%f,%f)\n",globalArray[i].name,globalArray[i].coordinates[j].x,globalArray[i].coordinates[j].y);
                }*/
            } 
            
        } 
    }

    void pushClosedPolyline(char* newPolyName, char* copyFromPolyName, bool check){
        if(!strcmp(newPolyName,copyFromPolyName) && !check ){ //ending the function if the assign is of the type p1 = p1 (useless)
            return;
        }
        
        int newPos = killProgram(newPolyName);
        //assumo che se la polilinea che voglio aggiungere gia esiste, allora termino il progamma

        bool exit = false;
        for(int i=0;i<counterGlobalArray && !exit;i++){
            //match della polylinea interessata
            if(globalArray[i].coordinates[0].x == globalArray[i].coordinates[globalArray[i].numPoints-1].x && globalArray[i].coordinates[0].y == globalArray[i].coordinates[globalArray[i].numPoints-1].y ){
                check = false;
                //printf("already close");
            }
            if(!strncmp(globalArray[i].name,copyFromPolyName,(strlen(copyFromPolyName)))){ //TO DO:  ATTENZIONE, NAME HA CARATTERE TERMINATORE IN PIU
                //printf("%s\n",globalArray[i].name);
                int numPointTemp = globalArray[i].numPoints+1;
                polyline tempPoly = {numPointTemp}; //piu uno perchè devo aggiungere il punto di chiusura
                strcpy(tempPoly.name, newPolyName);

                for(int j=0;j<globalArray[i].numPoints;j++){
                    tempPoly.coordinates[j] = globalArray[i].coordinates[j];
                    //printf("point(%f,%f)\n",tempPoly.coordinates[j].x,tempPoly.coordinates[j].y);
                }

                //printf("numpuntitot %d\n",tempPoly.numPoints);
                if(check)
                    tempPoly.coordinates[tempPoly.numPoints-1] = tempPoly.coordinates[0];
                else
                    tempPoly.numPoints -= 1;

                /*
                for(int j=0;j<tempPoly.numPoints;j++){
                    printf("point(%f,%f)\n",tempPoly.coordinates[j].x,tempPoly.coordinates[j].y);
                }*/

                globalArray[newPos] = tempPoly;

                //printf("poly:%s, totPunti:%d puntoStart(%f,%f), puntoEnd(%f,%f)\n",newPolyName,globalArray[counterGlobalArray].numPoints,globalArray[counterGlobalArray].coordinates[0].x,globalArray[counterGlobalArray].coordinates[0].y,globalArray[counterGlobalArray].coordinates[globalArray[counterGlobalArray].numPoints-1].x,globalArray[counterGlobalArray].coordinates[globalArray[counterGlobalArray].numPoints-1].y);

                counterCoordinatesTemp = 0;
                counterGlobalArray ++;

                exit = true;
            } 
            
        }
    }

    void pushPlusPolyline(char* newPoly, char* poly1, char* poly2){
        int newPos = killProgram(newPoly);
        //printf("%s,%s,%s",newPoly,poly1,poly2);ca
        bool exit = false;
        polyline tempPoly;
        
        for(int i=0;i<counterGlobalArray && !exit;i++){
            //printf("%s -> %d %s -> %d  : %d \n",globalArray[i].name,strlen(globalArray[i].name),poly1,strlen(poly1),!strncmp(globalArray[i].name,poly1,(strlen(poly1)-1)));
            //match della polylinea interessata
            if(!strncmp(globalArray[i].name,poly1,(strlen(poly1)))){ //TO DO:  ATTENZIONE, NAME HA CARATTERE TERMINATORE IN PIU
                //printf("%s\n",globalArray[i].name);
                tempPoly.numPoints = globalArray[i].numPoints;
                strcpy(tempPoly.name, newPoly);
                
                for(int j=0;j<globalArray[i].numPoints;j++){
                    tempPoly.coordinates[j] = globalArray[i].coordinates[j];
                    //printf("point(%f,%f)\n",tempPoly.coordinates[j].x,tempPoly.coordinates[j].y);
                }
                exit = true;
            } 
        }
        exit = false;
        //printf("%s\n\n\n",poly2);
        //printf("%s -> %d %s -> %d  : %d \n",globalArray[i].name,strlen(globalArray[i].name),poly2,strlen(poly2),!strncmp(globalArray[i].name,poly2,(strlen(poly2))));
        for(int i=0;i<counterGlobalArray && !exit;i++){
            //printf("%s -> %d %s -> %d \n",globalArray[i].name,strlen(globalArray[i].name),poly1,strlen(poly1));
            //match della polylinea interessata
            if(!strncmp(globalArray[i].name,poly2,(strlen(poly2)))){ //TO DO:  ATTENZIONE, NAME HA CARATTERE TERMINATORE IN PIU
                //printf("%s\n",globalArray[i].name);
                int offset = tempPoly.numPoints;
                tempPoly.numPoints += globalArray[i].numPoints;
                int pointToRemove = 0;
                for(int j=0;j<globalArray[i].numPoints;j++){
                    if(tempPoly.coordinates[j+offset-1].x == globalArray[i].coordinates[j].x && tempPoly.coordinates[j+offset-1].y == globalArray[i].coordinates[j].y)
                    {    printf("punto sovrapposto!\n");
                         pointToRemove++;}
                    else
                        tempPoly.coordinates[j+offset-pointToRemove] = globalArray[i].coordinates[j];
                    //printf("point(%f,%f)\n",tempPoly.coordinates[j+offset].x,tempPoly.coordinates[j+offset].y);
                }
                tempPoly.numPoints -= pointToRemove;
                /*
                P1 = 1 -2 -3 4 5 6
                P2 = 3 3 6 1 5 -2
                P3 = P2 + P1
                for(int j=0;j<tempPoly.numPoints;j++){
                    printf("point(%f,%f)\n",tempPoly.coordinates[j].x,tempPoly.coordinates[j].y);
                }*/
            
                //printf("poly:%s, totPunti:%d puntoStart(%f,%f), puntoEnd(%f,%f)\n",newPolyName,globalArray[counterGlobalArray].numPoints,globalArray[counterGlobalArray].coordinates[0].x,globalArray[counterGlobalArray].coordinates[0].y,globalArray[counterGlobalArray].coordinates[globalArray[counterGlobalArray].numPoints-1].x,globalArray[counterGlobalArray].coordinates[globalArray[counterGlobalArray].numPoints-1].y);
                exit = true;
            } 
        }



        //salvo la nuova polilinea
        globalArray[newPos] = tempPoly;
        counterCoordinatesTemp = 0;
        counterGlobalArray ++;
    }


    

%}

%union {
    int valInt;
    float valFloat;
    char* string;
}
%token SIMX SIMY SIM0 ISOPEN PLUS LPAR RPAR CLOSE EQ EOL 
%token <valFloat> NUMBER
%token <string> STRING  
%type <valFloat> point
%type <valFloat> polyline;
%%

line : 
     | line {polyName = false;} polyline EOL                {}
     ;

polyline: STRING EQ CLOSE STRING                {pushClosedPolyline($1,$4,true);counterCoordinatesTemp = 0;} //TO DO: SCOPRI EPRCHE NON RIESCI A PRENDERTI DIRETTAMENTE STRIN
        | STRING EQ STRING                      {pushClosedPolyline($1,$3,false);counterCoordinatesTemp = 0;} //TO DO: non richiesto da fare
        | STRING EQ STRING PLUS STRING          {pushPlusPolyline($1,$3,$5);} //TO DO: SCOPRI EPRCHE NON RIESCI A PRENDERTI DIRETTAMENTE STRIN
        | STRING EQ {polyName = true;}  def     {pushPolyline($1);counterCoordinatesTemp = 0;} //TO DO: SCOPRI EPRCHE NON RIESCI A PRENDERTI DIRETTAMENTE STRING E DEVO FARE LA CAZZO DI STRTOK
        | CLOSE def                             {printisCloseTempPoint();counterCoordinatesTemp = 0;}
        | ISOPEN def                            {printisOpenTempPoint();counterCoordinatesTemp = 0;}
        | ISOPEN STRING                         {printisOpenPolyLine($2);}
        | def                                   {printTempPointStats();counterCoordinatesTemp = 0;}
        | STRING                                {printPolyLineStat($1);}
        ;

def: SIMX {yFlag = yFlag ? false : true;} LPAR  def RPAR {yFlag = yFlag ? true : false;} def69     {}
   | SIMY {xFlag = xFlag ? false : true;} LPAR def RPAR {xFlag = xFlag ? true : false;} def69     {}
   | SIM0 {yFlag = yFlag ? false : true;xFlag = xFlag ? false : true;} LPAR def RPAR {yFlag = yFlag ? true : false;xFlag = xFlag ? false : true;} def69 {}
   | point def                          {}
   | point                              {}
   ;

def69: def                              {}
    | 
    ;

point: NUMBER NUMBER                    {push($1,$2);counterCoordinatesTemp++;}
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

