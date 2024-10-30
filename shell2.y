%union	{
		char   *string_val;
        char *str;
}

%token	<str> WORD 

%token  GREAT NEWLINE APPEND READ PIPE BACKGROUND EXIT ERR INTO REMOVE
%token TIME WITH IN LONG ITEMS ALL FILES FORCE RECURSIVE DIRECTORY CREATE LINES CONTENT SHOW LIST COPY CURRENT PATH PRINT
%token MOVE NP KILL PROCESS ZIP  UNZIP MAN KEYWORD GOTO PRE 
%type<str> argument 
%type<str> command_word  arg_list rmArg rmTypes createTypes  copyTypes MoveTypes zipTypes unzipTypes changeTypes

%{
extern "C" 
{
	int yylex();
	void yyerror (char const *s);
}
#define yylex yylex
#include <stdio.h>
#include "command.h"
%}

%left PIPE
%left BACKGROUND
%left GREAT APPEND READ


%%

goal:	
	commands
	;

commands: 
	command
	| commands command 
	;

command: simple_command
        ;

simple_command:
	EXIT NEWLINE{
		printf("\n\t\t\t Good Bye! :)\n\n");
		exit(0);
	}
	| command_and_args iomodifier_opt BACKGROUND NEWLINE {
		printf("   Yacc: insert background = TRUE\n");
	 	Command::_currentCommand._background=1;
		printf("   Yacc: Execute command\n");
		Command::_currentCommand.execute();
		exit(0);
	}
	| command_and_args iomodifier_opt NEWLINE {
		printf("   Yacc: Execute2 command\n");
		Command::_currentCommand.execute();
		exit(0);
	}
	| command_and_args iomodifier_opt PIPE commands {
		printf("   Yacc: Execute command\n");
		Command::_currentCommand.execute();
		exit(0);
	}
	| NEWLINE {exit(0);} 
	| error NEWLINE { yyerrok; exit(0); }
	;

command_and_args:
	command_word arg_list {        
            Command::_currentSimpleCommand = new SimpleCommand();

        if($1!=NULL){
        // printf("%s,",$1);
        Command::_currentSimpleCommand->insertArgument($1);
        }

        if ($2 != NULL) {
            char *arg_copy = strdup($2);
            char *token = strtok(arg_copy, " "); // Split by spaces
            while (token != NULL) {
				// printf("%s,",token);
                Command::_currentSimpleCommand->insertArgument(token); // Insert each argument
                token = strtok(NULL, " ");
            }
            free(arg_copy); 
        }
        Command::_currentCommand.insertSimpleCommand( Command::_currentSimpleCommand );
		
	}
	
	;

arg_list:
    arg_list argument {

    char wh[1024]; 
    memset(wh, 0, sizeof(wh)); 

    if ($1 != NULL) {
        strncpy(wh, $1, sizeof(wh) - 1);  // Copy first argument with buffer size check
    }

    if ($2 != NULL) {
        
        if ($1 != NULL) {
            strncat(wh, " ", sizeof(wh) - strlen(wh) - 1);  
        }
        strncat(wh, $2, sizeof(wh) - strlen(wh) - 1);  
    }

    $$ = strdup(wh); 
}

    | {
        $$ = NULL;
    }
    ;


argument:
	
	rmArg
	|IN LONG{
		printf("   IN LONG is changed to -l\n");
		printf("   Yacc: insert argument -l\n");
		$$=strdup("-l");
	}
	|ALL {
		printf("   ALL is changed to -a\n");
		printf("   Yacc: insert argument -a\n");
		$$=strdup("-a");
	}
	| ALL ITEMS{
		printf("   ALL is changed to -a\n");
		printf("   Yacc: insert argument -a\n");
		$$=strdup("-a");
	}
	|WITH LINES{
		printf("   Yacc: insert argument -n\n");
		$$=strdup("-n");
	}
	|KEYWORD {
		printf("   Yacc: insert argument -k\n");
		$$=strdup("-k");
	}
	|WORD {
        printf("   Yacc: insert2 argument \"%s\"\n", $1);
	    $$=$1;
	}
	|PRE DIRECTORY {
		printf("	yacc inserted argument ..\n");
		$$=strdup("..");
	}
	

	;

command_word:
	shTypes ITEMS{
		printf("	Yacc: insert command list\n");
		printf("	List Items is changed to ls\n");
		$$ = strdup("ls"); 
    }
	|shTypes CONTENT  FILES {
		printf("	Yacc: insert command list\n");
		printf("	List content is changed to ls\n");
		$$ = strdup("cat"); 
    }
	|shTypes CONTENT {
		printf("	Yacc: insert command list\n");
		printf("	List content is changed to ls\n");
		$$ = strdup("ls"); 
    }
	|shTypes{
		printf("	Yacc: insert command list\n");
		printf("	List Items is changed to ls\n");
		$$ = strdup("ls"); 
	}
	|shTypes CONTENT IN DIRECTORY{
		printf("	Yacc: insert command list\n");
		printf("	List Items is changed to ls\n");
		$$ = strdup("ls"); 
	}
	|rmTypes
	|WORD {
           printf("   Yacc: insert command \"%s\"\n", $1);
           $$=$1;
	}
	|createTypes
	|CURRENT DIRECTORY PATH {
		printf("	Yacc: inserted command \"current dir\" \n");
		$$=strdup("pwd");
	}
	|PATH CURRENT DIRECTORY {
		printf("	Yacc: inserted command \"current dir\"\n ");
		$$=strdup("pwd");
	}
	|SHOW PATH CURRENT DIRECTORY {
		printf("	Yacc: inserted command \"current dir\"\n ");
		$$=strdup("pwd");
	}
	|copyTypes
	|MoveTypes
	|PRINT {
		printf("YACC: inserted command PRINT\n");
		$$=strdup("echo");
	}
	|SHOW NP {
		printf("YACC: inserted command RUNNING PROCESS\n");
		printf("NP CHANGED TO PS\n");
		$$=strdup("ps");
	}
	|SHOW ALL NP {
		printf("YACC: inserted command RUNNING PROCESS\n");
		printf("NP CHANGED TO PS\n");
		$$=strdup("ps");
	}
	|KILL PROCESS {
		printf("Yacc: Inserted Command KIll\n");
		printf("ChaNGED To kill\n");
		$$=strdup("pkill");
	}
	|zipTypes
	|unzipTypes
	|MAN {
		printf("Yacc: Inserted Command man\n");
		printf("ChaNGED To man\n");
		$$=strdup("man");
	}
	|SHOW MAN {
		printf("Yacc: Inserted Command man\n");
		printf("ChaNGED To man\n");
		$$=strdup("man");
	}
	|changeTypes
	
	;

iomodifier_opt:
	INTO WORD{
		printf(" into is subscripted to > ");
		printf("   Yacc: insert output \"%s\"\n", $2);
		Command::_currentCommand._outFile = $2;
	}

	|GREAT WORD {
		printf("   Yacc: insert output \"%s\"\n", $2);
		Command::_currentCommand._outFile = $2;
	}
	| APPEND WORD {
		printf("   Yacc: insert append output \"%s\"\n", $2);
		Command::_currentCommand._outFile = $2;
		Command::_currentCommand._append = 1;
	}
	| READ WORD {
		printf("   Yacc: insert input \"%s\"\n", $2);
		Command::_currentCommand._inputFile = $2;
	}
	| READ WORD GREAT WORD {
		printf("   Yacc: insert output \"%s\"\n", $4);
		Command::_currentCommand._outFile = $4;
		printf("   Yacc: insert input \"%s\"\n", $2);
		Command::_currentCommand._inputFile = $2;
	}
	| READ WORD APPEND WORD {
		printf("   Yacc: insert append output \"%s\"\n", $4);
		Command::_currentCommand._outFile = $4;
		printf("   Yacc: insert input \"%s\"\n", $2);
		Command::_currentCommand._inputFile = $2;
		Command::_currentCommand._append = 1;
	}
	| ERR WORD {
		printf("   Yacc: insert error \"%s\"\n", $2);
		Command::_currentCommand._errFile = $2;
	}
	|
	;
shTypes:
	LIST
	|SHOW
	;
rmArg:
	FORCE {
		printf("   FORCE  is changed to -f\n");
		printf("   Yacc: insert argument -f\n");
		$$=strdup("-f");
	}
	|RECURSIVE {
		printf("   RECURSIVE  is changed to -r\n");
		printf("   Yacc: insert argument -r\n");
		$$=strdup("-r");
	}
	|rmArg FORCE{
		printf("   RECURSIVE FORCE  is changed to -rf\n");
		printf("   Yacc: insert argument -rf\n");
		$$=strdup("-rf");
	}
	;
rmTypes:
	REMOVE{
		printf("	Yacc: insert command remove\n");
		printf("	Remove is changed to rm\n");
		$$ = strdup("rm"); 
	}
	|REMOVE FILES{
		printf("	Yacc: insert command remove\n");
		printf("	Remove file is changed to rm\n");
		$$ = strdup("rm"); 
	}
	|REMOVE DIRECTORY{
		printf("	Yacc: insert command remove directory\n");
		printf("	Remove directory is changed to rmdir\n");
		$$ = strdup("rmdir"); 
	}
	;
createTypes:
	CREATE FILES{
		printf("	Yacc: insert command create  file \n");
		printf("	create file is changed to touch\n");
		$$ = strdup("touch"); 
	}
	|CREATE DIRECTORY{
		printf("	Yacc: insert command create  dir \n");
		printf("	create dir is changed to mkdir\n");
		$$ = strdup("mkdir"); 
	}
	;
copyTypes:
	COPY {
		printf("	Yacc: inserted command \"Copy\"\n ");
		printf("	COPY is changed to cp\n ");
		$$=strdup("cp");	
	}
	|COPY FILES {
		printf("	Yacc: inserted command \"Copy\"\n ");
		printf("	COPY is changed to cp\n ");
		$$=strdup("cp");	
	}
	;
MoveTypes:
	MOVE {
		printf("	Yacc: inserted command \"MOVE\"\n ");
		printf("	MOVE is changed to mc\n ");
		$$=strdup("mv");	
	}
	|MOVE FILES {
		printf("	Yacc: inserted command \"MOVE\"\n ");
		printf("	MOVE is changed to mc\n ");
		$$=strdup("mv");		
	}
	;
zipTypes:
	ZIP {
		printf("Yacc: Inserted Command ZIP\n");
		printf("ChaNGED To zip\n");
		$$=strdup("zip");
	}
	|ZIP FILES {
		printf("Yacc: Inserted Command ZIP");
		printf("ChaNGED To zip\n");
		$$=strdup("zip");
	}
	|CREATE ZIP FILES {
		printf("Yacc: Inserted Command ZIP");
		printf("ChaNGED To zip\n");
		$$=strdup("zip");
	}
	;
unzipTypes:
	UNZIP {
		printf("Yacc: Inserted Command UNZIP\n");
		printf("ChaNGED To unzip\n");
		$$=strdup("unzip");
	}
	|UNZIP FILES{
		printf("Yacc: Inserted Command UNZIP\n");
		printf("ChaNGED To unzip\n");
		$$=strdup("unzip");
	}
	;
changeTypes:
	GOTO {
		printf("Yacc: Inserted Command Goto\n");
		printf("ChaNGED To cd\n");
		$$=strdup("cd");
	}
	|GOTO DIRECTORY {
		printf("Yacc: Inserted Command Goto\n");
		printf("ChaNGED To cd\n");
		$$=strdup("cd");
	}
    ;



%%

void
yyerror(const char * s)
{
	fprintf(stderr,"%s", s);
}

#if 0
main()
{
	
	yyparse();
}
#endif

