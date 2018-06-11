%{
#include "html.h"
#include "pag.h"
#include <glib.h>

int tem;
char *nom;
FILE *fichInicial, fichCredit;

Gtree* arv = g_tree_new_full((GCompareDataFunc)g_ascii_strcasecmp, NULL, NULL, (GDestroyNotify)freepag);

%}

%union{
    char* nome;
    int tempo;
    char* atributo;
}

%type <nome> NOME
%type <tempo> TEMPO
%type <atributo> IMAGEM VIDEO TITULO AUDIO ITENS PAGINICIAL PAGCREDITOS

%token NOME TEMPO IMAGEM VIDEO TITULO AUDIO ITENS PAGINICIAL PAGCREDITOS

%%
start: pag start
     |
     ;

pag: cabecalho informacao
    ;

cabecalho: NOME '/' TEMPO {strcpy(nom,$1); tem = $3;}

informacao: '{' IMAGEM VIDEO TITULO AUDIO pagitens '}'
          | '{' PAGINICIAL '}' {imprime_inicial(fichInicial, tem, nome);}
          | '{' PAGCREDITOS '}' {imprime_cred(fichCredit);}
          ;

pagitens: '[' ITENS ']'
    ;


%%
int main(int argc, char** argv){
  fichInicial = fopen("html/pagInicial.html","w+"); 
  fichCredit = fopen("html/pagCredit.html","w+");
  yyparse();

}

int yywrap(){
   return 1;
}

void yyerror (char const *s) {
   fprintf (stderr, "%s\n", s);
}

