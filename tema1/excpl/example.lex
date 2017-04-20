int num_lines = 0;
%option noyywrap
%%

\n	num_lines++;

%%
main(void) {
	yylex();
	printf("# of lines = %d\n", num_lines);
}
