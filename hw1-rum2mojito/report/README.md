# hw1 report

|Field|Value|
|-:|:-|
|Name|石育瑋|
|ID|A073708|

## How much time did you spend on this project

2.5 hours.

## Project overview

### 正則表達式
> 這次作業難點在完成各種不同狀況下正則表達式的寫法，主要包含的有:
```
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
```
- letter: letter表達的是26個大小寫英文字母，其中我看網路上一些資料會包含"_"，但在助教的測資裡是不包含的
- digit: 表達所有0-9的數字
- int: 因為integer開頭不能是0，所以一開始只能是[1-9]後續接上所以digit的排列組合({digit}*)
- zero: 又整數零為整數中的特例，只有他開頭可以是0，所以特別拿出來獨立表達0
- octint: 開頭是0，後續只能接[0-8]
- float: 浮點數透過"."切開成兩部分，前半部分為一般整數，後面也為一般整數
- scientific: [eE]前半為整數或浮點數，後半也為整數或浮點數
- string: 一般字符串只要看""，但測資裡有特例""->"，需要別處理
```
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
```
- delimiter: 按照spec要求的內容
- S_on/off, T_on/off: 按照spec要求的內容
```
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
```
- operator: 按照spec要求的內容
- keyword: 按照spec要求的內容

### COMMENT處理 

> case1: /* */
```
在<INITIAL>狀態下遇到"/*"時，切換至<COMMENT>狀態，並對遇到的所有字串用LIST紀錄，但不tokenizing；最後遇到"*/"時，切回<INITIAL>狀態．
```
  
> case2: //
```
在<INITIAL>狀態下遇到"//"時，切換至<COMMENT_CPP>狀態，並對遇到的所有字串用LIST紀錄，但不tokenizing；最後遇到"\n"時，切回<INITIAL>狀態．
```

## What is the hardest you think in this project

flex中正則表達式的語法

## Feedback to T.A.s

> 測資有點小問題
