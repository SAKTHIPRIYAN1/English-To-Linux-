
%{

#include <string.h>
#include "y.tab.h"

%}

%%

[mM][aA][nN][uU][Aa][lL] {
	return MAN;
}

[kK][eE][yY][wW][oO][rR][dD] {
	return KEYWORD;
}


[lL][iI][sS][tT] {
	return LIST;
}
[sS][hH][oO][wW] {
	return SHOW;
}

[iI][tT][eE][mM][sS]  {
	return ITEMS;
}

[aA][lL][lL] {
	return ALL;
}

[iI][nN][tT][oO] {
	return INTO;
}

[wW][iI][tT][hH] {
	return WITH;
}
[lL][iI][nN][eE][sS] {
	return LINES;
}
[tT][iI][mM][eE] {
	return TIME;
}

[iI][nN] {
	return IN;
}

[Ll][oO][nN][gG] {
	return LONG;
}

[rR][eE][mM][oO][vV][eE]|[Dd][Ee][lL][eE][tT][eE] {
	return REMOVE;
}

[fF][iI][lL][eE] {
	return FILES;
}

[fF][oO][Rr][Cc][eE]|[fF][oO][Rr][Cc][eE][fF][uU][lL][lL][yY] {
	return FORCE;
}
[dD][iI][rR][eE][cC][tT][oO][rR][yY] {
	return DIRECTORY;
}
recursive {
    return RECURSIVE;
}
[cC][rR][eE][aA][tT][eE] {
	return CREATE;
}

[cC][oO][nN][tT][eE][nN][tT] {
	return CONTENT;
}
[cC][oO][pP][yY] {
	return COPY;
}
[cC][uU][rR][rR][eE][nN][tT] {
	return CURRENT;
}
[pP][aA][tT][hH] {
	return PATH;
}



[rR][uU][nN][nN][iI][nN][gG]\ [pP][rR][oO][cC][eE][sS][sS] {
	return NP;
}

[sS][tT][oO][pP]|[kK][iI][lL][lL] {
	return KILL;
}

[pP][rR][oO][cC][eE][sS][sS] {
	return PROCESS;
}




[Mm][oO][vV][eE] {
	return MOVE;
}

[pP][rR][iI][nN][tT] {
	return PRINT;
}
[uU][nN][zZ][iI][pP] {
	return UNZIP;
}
[zZ][iI][pP] {
	return ZIP;
}

[Gg][oO][Tt][oO]|[cC][hH][aA][nN][gG][eE] {
	return GOTO;
}

[pP][rR][eE][vV][iI][oO][uU][sS] {
	return PRE;
}

"make" {}
"from "|" from " {}
"to "|" to " {}
"the"|" The "|" THE " |" the " |"the "|" the" {}
"give" {}
"working" {}
"me"|" me "|" me"|"me " {}
" a "|" A " {}
" called "|" Called " {}
"of " |" of" |" of " {}
"this" {}
" " {}

\n 		{
		return NEWLINE;
		}

[ \t]+ 	{
		/* Discard spaces and tabs */
     	}

"&>>"	{
		return ERR;
		}
">>"	{
		return APPEND;
		}	

">" 	{
		return GREAT;
		}

"<"		{
		return READ;
		}

"&"		{
		return BACKGROUND;
		}

"|"		{
		return PIPE;
		}
"exit"	{
		return EXIT;
		}

[^ \t\n\>\<\|\&]+  {
		/* Assume that file names have only alpha chars */
		// printf("DD:%s\n",yytext);
		yylval.str = strdup(yytext);
		return WORD;
	}


%%
	

