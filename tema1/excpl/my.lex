
DIGIT [0-9]

%%

[a-z]* {
	printf(\n text: %s\n", yytext); 
}

{DIGIT}+ {
	
	printf("\nA number: %s\n", yytext );	
}

{DIGIT}+"."{DIGIT}* {

	printf("\nA float %s\n", yytext);
}

%%

main(argc, argv)
int argc;
char **argv;
   {
   yyin = stdin;
   yyout = fopen(argv[1], "w");
   yylex();
   }