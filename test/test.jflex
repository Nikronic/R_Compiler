// import java_cup.runtime.Symbol;
// import java_cup.runtime.ComplexSymbolFactory;
// import java_cup.runtime.ComplexSymbolFactory.Location;


%%

%class Lexer
%line
// %cup
%char
// %implements sym, minijava.Constants
%column
%standalone
// %standalone

new_line = \r|\n|\r\n;
white_space = {new_line} | [ \t\f]
whitespace = [\n\t ]+
// keywords = if|array|list|library|while|function
string_literal = \"([^\"])*\" //   (\")(.)*?(\") // ([""])(.)*?\1
identifier = [a-zA-Z_][\w.]*|\.[a-zA-Z_][\w.]*
integer_literal = [+-]?[1-9][0-9]*[lL]?|0[xX][0-9a-fA-F]+
bool_literal=TRUE|FALSE
// float_literal = [+-]?([0-9]+([.][0-9]*)?|[.][0-9]+)
// delimiters = [(){}<>[]]
// arith_operators =   [+\-*/\^]|%[*/o]?%|%{identifier}%
// logic_operators = <=|>=|==|\!=|>|<|\!|&[&]?|\|[\|]?|:|\?|\~|\$
// assignment_operators = =|->[>]?|<[<]?-
// operators = {logic_operators}|{arith_operators}|{assignment_operators}
comments = #.*
%{

    public void printMatch(String type) {
         System.out.printf("Found match %s , at line %d, column %d => %s\n",
         yytext(),yyline,yycolumn,type);
    }

%}

// %eofval{
//      return symbolFactory.newSymbol("EOF", EOF, new Location(yyline+1,yycolumn+1,yychar), new Location(yyline+1,yycolumn+1,yychar+1));
// %eofval}

%%

"if" { printMatch("if"); }
"else" { printMatch("else"); }
"for" { printMatch("for"); }
"in" { printMatch("in"); }
"function" { printMatch("function"); }
";" { printMatch(";"); }
"," { printMatch(","); }
"(" { printMatch("("); }
")" { printMatch(")"); }
"{" { printMatch("{"); }
"}" { printMatch("}"); }
"<-" { printMatch("<-"); }
"+" { printMatch("+"); }
"-" { printMatch("-"); }
"*" { printMatch("*"); }
"/" { printMatch("/"); }
"<=" { printMatch("<="); }
">=" { printMatch(">="); }
"==" { printMatch("=="); }
"!=" { printMatch("!="); }
"<"  { printMatch("<"); }
">"  { printMatch(">"); }
"&&" { printMatch("&&"); }
"||" { printMatch("||"); }
"!"  { printMatch("!"); }
// {keywords} { printMatch(yytext(),yyline,yycolumn,"keyword");}
{identifier} { printMatch("identifier"); }
{string_literal} { printMatch("string_literal");}
{integer_literal} { printMatch("integer_literal"); }
// {float_literal} { printMatch(); }
// {operators} { printMatch(yytext(),yyline,yycolumn,"operators");}
{comments} { printMatch("comments");}
// {delimiters} { printMatch(yytext(),yyline,yycolumn,"delimiters");}
/* bool literal */
{bool_literal} { printMatch("bool_literal"); }

/* literals */
// {whitespace} { printMatch(yytext(),yyline,yycolumn,"whitespace");}
{whitespace} { printMatch("whitespace"); }

