%%

%class Flexer
%unicode
//%debug
%int
%line
%column

%{
    Alphabet alphabet = new Alphabet();
    Rules rules = new Rules();
    Neterminali net = new Neterminali();
    Terminals ter = new Terminals();
    Character start;

    void addSymbol(Character c) {

        alphabet.addSymbol(c);
    }
%}

LineTerminator = \r|\n|\r\n
WS = {LineTerminator} | [ \t\f]
lower = [a-d]|[f-z]
digit = [0-9]
other = "-"|"="|"["|"]"|";"|"\\"|"."|"/"|"~"|"!"|"@"|"#"|"$"|"%"|"^"|"&"|"*"|"_"|
        "+"|":"|"|"|"<"|">"|"?"|"'"|"`"|"\""
neterminals = [A-Z]
terminals = {lower} | {digit} | {other}
all = {terminals} | {neterminals}
alle = {all} | "e"


%state V PREALPHABET ALPHABET PRERULES RULES START

%%

{WS}	{/*Skip whitespace in any state*/}


<YYINITIAL> { 

    "("{WS}*"{"{WS}* {yybegin(V);}
    . {return 1;}
}


<V> {

   {all}{WS}*","{WS}* { 
       String symbol = yytext();
       alphabet.addSymbol(symbol.charAt(0));
       yybegin(V);
     }

    {all}{WS}*"}"{WS}* {
       String symbol = yytext();
       alphabet.addSymbol(symbol.charAt(0));
       yybegin(PREALPHABET);
    }

    . { return 1; }
}

<PREALPHABET> {

    {WS}*","{WS}*"{"{WS}*"}"{WS}* { yybegin(PRERULES); } //poate fi vida
    {WS}*","{WS}*"{"{WS}* { yybegin(ALPHABET); }
    . { return 1; }
}

<ALPHABET> {    

    {all}{WS}*","{WS}* {
        String symbol = yytext();
        ter.addSymbol(symbol.charAt(0));
        yybegin(ALPHABET);
    }

    {all}{WS}*"}"{WS}* {

        String symbol = yytext();
        ter.addSymbol(symbol.charAt(0));
        yybegin(PRERULES);
    }

    . {return 1;}
}

<PRERULES> {

    {WS}*","{WS}*"{"{WS}*"}"{WS}* { return 0; } // poate fi vida
    {WS}*","{WS}*"{"{WS}* { yybegin(RULES); }

    
    . {return 1;}
}

<RULES> {

    "("{WS}*{neterminals}{WS}*","{WS}*{alle}*{WS}*")"{WS}*"}"{WS}* {

        String symbol = yytext();
        symbol = symbol.replaceAll(" ", "");
        symbol = symbol.substring(0, symbol.length() - 2);
        String[] buckets = symbol.split(",");
        rules.addRule(buckets[0].charAt(1), buckets[1]);
        yybegin(START);
    }

    "("{WS}*{neterminals}{WS}*","{WS}*{alle}*{WS}*")"{WS}*","{WS}* {

        String symbol = yytext();
        symbol = symbol.replaceAll(" ", "");
        symbol = symbol.substring(0, symbol.length() - 2);
        String[] buckets = symbol.split(",");
        rules.addRule(buckets[0].charAt(1), buckets[1]);
        yybegin(RULES);
    }

    . { return 1; }
}

<START> {

    {WS}*","{WS}*{neterminals}{WS}*")"{WS}* { 

        String symbol = yytext();
        symbol = symbol.replaceAll(" ", "");
        start = symbol.charAt(1);
        return 0;
    }
    . {return 1;}

}


