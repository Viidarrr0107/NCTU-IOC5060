%{
#define LIST               strcat(buf, yytext)
#define token(t)           {LIST; if (Opt_T) printf("<%s>\n", #t);}
#define tokenS(s)           {LIST; if (Opt_T) printf("<%s>\n", (s));}
#define tokenChar(t)       {LIST; if (Opt_T) printf("<%c>\n", (t));}
#define tokenInteger(t, i) {LIST; if (Opt_T) printf("<%s: %d>\n", #t, (i));}
#define tokenString(t, s)  {LIST; if (Opt_T) printf("<%s: %s>\n", #t, (s));}
// Define your token macros here
//  for example :
//    #define tokenScientific(t, s)   <definition>
//    #define tokenFloat(ts)          <definition>
//    #define <any other macros you needed>

#define MAX_LINE_LENG      256

int Opt_S = 1;
int Opt_T = 1;
int linenum = 1;
char buf[MAX_LINE_LENG];
char string_buf[MAX_LINE_LENG];
%}

letter    [a-zA-Z]
digit     [0-9]
int       [1-9]{digit}*
zero      0
octint    0[0-8]+
dot       .
float     ({int}|0)\.{digit}*[1-9]+|({int}|0)\.0
s_float    ({int}){dot}(0*{digit})+|-({int}){dot}(0*{digit})+
scientific  ({int}|{s_float})[Ee][+-][1-9]{digit}*|({int}|{s_float})[Ee][1-9]{digit}*
scientific_z  ({int}|{s_float})[Ee][+-]0*|({int}|{s_float})[Ee]0
identifer {letter}({letter}|{digit})*
space     [ \t]
string    \"([^\"]|\"\")*\"
delimiter [,;:()\[\]]
end_line  \n
S_on      \/\/\&S\+
S_off     \/\/\&S\-
T_on      \/\/\&T\+
T_off     \/\/\&T\-
operator  [+\-*/]|:=|=|mod|<|<=|<>|>=|>|=|and|or|not
keyword   array|begin|boolean|def|do|else|end|false|for|integer|if|of|print|read|real|string|then|to|true|return|var|while

%Start COMMENT COMMENT_CPP
%%
<INITIAL>{S_on} {
  LIST;
  Opt_S = 1;
  BEGIN COMMENT_CPP;
}

<INITIAL>{S_off} {
  LIST;
  Opt_S = 0;
  BEGIN COMMENT_CPP;
}

<INITIAL>{T_on} {
  LIST;
  Opt_T = 1;
  BEGIN COMMENT_CPP;
}

<INITIAL>{T_off} {
  LIST;
  Opt_T = 0;
  BEGIN COMMENT_CPP;
}

<COMMENT_CPP>{end_line} {
  // LIST;
  if (Opt_S)
    printf("%d: %s\n", linenum, buf);
  linenum++;
  buf[0] = '\0';
  BEGIN INITIAL;
}

<COMMENT_CPP>. { 
  LIST;
}

<COMMENT>"*/" {
  LIST;
  BEGIN INITIAL;
}

<COMMENT>{end_line} {
  // LIST;
  if (Opt_S)
    printf("%d: %s\n", linenum, buf);
  linenum++;
  buf[0] = '\0';
}

<COMMENT>. { 
  LIST;
}

<INITIAL>"/*" { 
  LIST;
  BEGIN COMMENT;
}

<INITIAL>"//" { 
  LIST;
  // printf("comment end\n");
  BEGIN COMMENT_CPP;
}

<INITIAL>{keyword} {
  char key_buf[MAX_LINE_LENG];
  key_buf[0] = '\0';
  strcat(key_buf, "KW");
  strcat(key_buf, yytext);
  tokenS(key_buf);
}

<INITIAL>{string} {
  string_buf[0] = '\0';
  int j = 0;
  for(int i=1; i<strlen(yytext)-1; i++) {
    string_buf[j] = yytext[i];
    if(yytext[i]=='"') {
      i++;
    }
    j++;
    string_buf[j] = '\0';
  }
  tokenString(string, string_buf);
}

<INITIAL>{scientific}|{scientific_z} {
  tokenString(scientific, yytext);
}

<INITIAL>{octint} {
  tokenString(oct_integer, yytext);
}

<INITIAL>{int}|{zero} {
  tokenInteger(integer, atoi(yytext));
}



<INITIAL>{float} {
  tokenString(float, yytext);
}

<INITIAL>{operator} {
  tokenS(yytext);
}

<INITIAL>{delimiter} {
  tokenS(yytext);
}

<INITIAL>{identifer} {
  tokenString(id, yytext);
}

<INITIAL>{space} {
  LIST;
}

<INITIAL>\n {
  // LIST;
  if (Opt_S)
    printf("%d: %s\n", linenum, buf);
  linenum++;
  buf[0] = '\0';
}

<INITIAL>. {
  LIST;
  /* error */
  printf("Error at line %d: bad character \"%s\"\n", linenum, yytext );
  exit(-1);
}
%%
int main( int argc, char **argv )
{
  if( argc != 2 ) {
    fprintf( stderr, "Usage: ./scanner [filename]\n" );
    exit(0);
  }
	
  FILE *fp = fopen( argv[1], "r" );
  if( fp == NULL ) {
    fprintf( stderr, "Open file error\n" );
    exit(-1);
  }
	
  yyin = fp;

  yylex();

  exit(0);
}
