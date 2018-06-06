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
"else" { return symbol("else",ELSE); }
"for" { return symbol("for",FOR); }
"function" { return symbol("function",FUNCTION); }
";" { return symbol("semicolon",SEMICOLON); }
"," { return symbol("comma",COMMA); }
"(" { return symbol("(",LPAR); }
")" { return symbol(")",RPAR); }
"{" { return symbol("{",BEGIN); }
"}" { return symbol("}",END); }
"<-" { return symbol("<-",ASSIGN); }
"+" { return symbol("plus",BINOP, new Integer( 	 ) ); }
"-" { return symbol("minus",BINOP, new Integer( MINUS ) ); }
"*" { return symbol("mult",BINOP, new Integer( MULT ) ); }
"/" { return symbol("div",BINOP, new Integer( DIV ) ); }
"<=" { return symbol("leq",COMP,  new Integer( LEQ ) ); }
">=" { return symbol("gtq",COMP,  new Integer( GTQ ) ); }
"==" { return symbol("eq",COMP,  new Integer( EQ  ) ); }
"!=" { return symbol("neq",COMP,  new Integer( NEQ ) ); }
"<"  { return symbol("le",COMP,  new Integer( LE  ) ); }
">"  { return symbol("gt",COMP,  new Integer( GT  ) ); }
"&&" { return symbol("and",BBINOP,new Integer( AND ) ); }
"||" { return symbol("or",BBINOP,new Integer( OR  ) ); }
"!"  { return symbol("not",BUNOP); }
// {keywords} { printMatch(yytext(),yyline,yycolumn,"keyword");}
{identifier} { return symbol("Identifier",IDENT, yytext()); }
// {string_literal} { printMatch(yytext(),yyline,yycolumn,"string_literal");}
{integer_literal} { return symbol("Intconst",INTCONST, new Integer(Integer.parseInt(yytext()))); }
{float_literal} { return symbol("Floatconst",FLOATCONST, new Integer(Float.parseFloat(yytext()))); }
// {operators} { printMatch(yytext(),yyline,yycolumn,"operators");}
{comments} { return symbol("Comments",COMMENTS);}
// {delimiters} { printMatch(yytext(),yyline,yycolumn,"delimiters");}
{whitespace} { }

// /* names */
// {Ident}           { return symbol("Identifier",IDENT, yytext()); }

// /* bool literal */
// {BoolLiteral} { return symbol("Boolconst",BOOLCONST, new Boolean(Boolean.parseBool(yytext()))); }

/* literals */
//{IntLiteral} { return symbol("Intconst",INTCONST, new Integer(Integer.parseInt(yytext()))); }
// {whitespace} { printMatch(yytext(),yyline,yycolumn,"whitespace");}

/* error fallback */
.|\n {  /* throw new Error("Illegal character <"+ yytext()+">");*/
		    error("Illegal character <"+ yytext()+">");
     }