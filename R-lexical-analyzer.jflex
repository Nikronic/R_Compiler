import java.util.*;



%%

%class RLexicalAnalyzer
%line
%column
%standalone
whitespace = [\n\t]+
keywords = if|array|list|library|while|function
string_literal = \"([^\"])*\" //   (\")(.)*?(\") // ([""])(.)*?\1
identifier = [a-zA-Z_][\w.]*|\.[a-zA-Z_][\w.]*
integer_literal = [+-]?[1-9][0-9]*[lL]?|0[xX][0-9a-fA-F]+
float_literal = [+-]?([0-9]+([.][0-9]*)?|[.][0-9]+)
delimiters = [(){}<>[]]
arith_operators = %\/%|[+\-*/\^]|%[*/xo]?(in)?%
logic_operators = <=|>=|==|\!=|>|<|\!|&[&]?|\|[\|]?|:|\?|~|\$
assignment_operators = =|->[>]?|<[<]?-
operators = {logic_operators}|{arith_operators}|{assignment_operators}
comments = #.*
%{
    public void printMatch(String text,int line,int column,String type) {
         System.out.printf("Found match %s , at line %d, column %d ===> %s",
         text,line,column,type);
    }
%}

%%
{keywords} { printMatch(yytext(),yyline,yycolumn,"keyword");}
{identifier} { printMatch(yytext(),yyline,yycolumn,"identifier");}
{string_literal} { printMatch(yytext(),yyline,yycolumn,"string_literal");}
{integer_literal} { printMatch(yytext(),yyline,yycolumn,"integer_literal");}
{float_literal} { printMatch(yytext(),yyline,yycolumn,"float_literal");}
// {arith_operators} { printMatch(yytext(),yyline,yycolumn); System.out.println("  ===> arith_operators");}
// {logic_operators} { printMatch(yytext(),yyline,yycolumn); System.out.println("  ===> logic_operators");}
// {assignment_operators} { printMatch(yytext(),yyline,yycolumn); System.out.println("  ===> assignment_operators");}
{operators} { printMatch(yytext(),yyline,yycolumn,"operators");}
{comments} { printMatch(yytext(),yyline,yycolumn,"comments");}
{delimiters} { printMatch(yytext(),yyline,yycolumn,"delimiters");}
{whitespace} { printMatch(yytext(),yyline,yycolumn,"whitespace");}