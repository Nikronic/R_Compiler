package cup.example;
import java_cup.runtime.ComplexSymbolFactory;
import java_cup.runtime.ComplexSymbolFactory.Location;
import java_cup.runtime.Symbol;
import java.lang.*;
import java.io.InputStreamReader;



%%

%class Lexer
%line
%cup
%char
%implements sym
%column
// %standalone

new_line = \r|\n|\r\n;
white_space = {new_line} | [ \t\f]
whitespace = [\n\t]+
// keywords = if|array|list|library|while|function
string_literal = \"([^\"])*\" //   (\")(.)*?(\") // ([""])(.)*?\1
identifier = [a-zA-Z_][\w.]*|\.[a-zA-Z_][\w.]*
integer_literal = [+-]?[1-9][0-9]*[lL]?|0[xX][0-9a-fA-F]+
float_literal = [+-]?([0-9]+([.][0-9]*)?|[.][0-9]+)
bool_literal=TRUE|FALSE
// delimiters = [(){}<>[]]
// arith_operators =   [+\-*/\^]|%[*/o]?%|%{identifier}%
// logic_operators = <=|>=|==|\!=|>|<|\!|&[&]?|\|[\|]?|:|\?|\~|\$
// assignment_operators = =|->[>]?|<[<]?-
// operators = {logic_operators}|{arith_operators}|{assignment_operators}
comments = #.*
%{
    StringBuffer string = new StringBuffer();
    public Lexer(java.io.Reader in, ComplexSymbolFactory sf){
	this(in);
	    symbolFactory = sf;
    }
    ComplexSymbolFactory symbolFactory;

  private Symbol symbol(String name, int sym) {
      return symbolFactory.newSymbol(name, sym, new Location(yyline+1,yycolumn+1,yychar), new Location(yyline+1,yycolumn+yylength(),yychar+yylength()));
  }

  private Symbol symbol(String name, int sym, Object val) {
      Location left = new Location(yyline+1,yycolumn+1,yychar);
      Location right= new Location(yyline+1,yycolumn+yylength(), yychar+yylength());
      return symbolFactory.newSymbol(name, sym, left, right,val);
  }
  private Symbol symbol(String name, int sym, Object val,int buflength) {
      Location left = new Location(yyline+1,yycolumn+yylength()-buflength,yychar+yylength()-buflength);
      Location right= new Location(yyline+1,yycolumn+yylength(), yychar+yylength());
      return symbolFactory.newSymbol(name, sym, left, right,val);
  }
  private void error(String message) {
    System.out.println("Error at line "+(yyline+1)+", column "+(yycolumn+1)+" : "+message);
  }
%}

%eofval{
     return symbolFactory.newSymbol("EOF", EOF, new Location(yyline+1,yycolumn+1,yychar), new Location(yyline+1,yycolumn+1,yychar+1));
%eofval}

%%
"if" { return symbol("if",IF); }
"in" { return symbol("if",IN); }
"else" { return symbol("else",ELSE); }
"for" { return symbol("for",FOR); }
"function" { return symbol("function",FUNCTION); }
"," { return symbol("comma",COMMA); }
"(" { return symbol("(",LPAR); }
")" { return symbol(")",RPAR); }
"{" { return symbol("{",BEGIN); }
"}" { return symbol("}",END); }
"<-" { return symbol("<-",ASSIGN); }
"+" { return symbol("plus",PLUS); }
"-" { return symbol("minus",MINUS); }
"*" { return symbol("mult",MULT); }
"/" { return symbol("div",DIV); }
"<=" { return symbol("leq",LEQ); }
">=" { return symbol("gtq",GTQ); }
"==" { return symbol("eq",EQ); }
"!=" { return symbol("neq",NEQ); }
"<"  { return symbol("le",LE); }
">"  { return symbol("gt",GT); }
"&&" { return symbol("and",AND); }
"||" { return symbol("or",OR); }
"!"  { return symbol("not",NOT); }
":"  { return symbol("colon",COLON);}
{identifier} { return symbol("Identifier",IDENT, yytext()); }
{integer_literal} { return symbol("INTCONST",INTCONST, new Integer(Integer.parseInt(yytext()))); }
{float_literal} { return symbol("FLOATCONST",FLOATCONST, new Float(Float.parseFloat(yytext()))); }
{bool_literal} { return symbol("BOOLCONST",BOOLCONST, new Boolean(Boolean.parseBool(yytext()))); }
{string_literal} { return symbol("STRINGCONST",STRINGCONST, yytext()); }
{comments} { return symbol("Comments",COMMENTS);}
{whitespace} { }

/* error fallback */
.|\n {  /* throw new Error("Illegal character <"+ yytext()+">");*/
		    error("Illegal character <"+ yytext()+">");
     }