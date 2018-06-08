package cup.example;
import java_cup.runtime.ComplexSymbolFactory;
import java_cup.runtime.ComplexSymbolFactory.Location;
import java_cup.runtime.Symbol;
import java.lang.*;
import java.io.InputStreamReader;

%%

%class Lexer
%implements sym
%public
%unicode
%line
%column
%cup
%char

line_terminator = \r|\n|\r\n
white_space = {line_terminator} | [ \t\f]
// keywords = if|array|list|library|while|function
string_literal = \"([^\"])*\" //   (\")(.)*?(\") // ([""])(.)*?\1
identifier = ([a-zA-Z_])([a-zA-Z0-9_.])*|([.][a-zA-Z_])([a-zA-Z0-9_.])*
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

    public Lexer(ComplexSymbolFactory sf, java.io.InputStream is){
		this(is);
        symbolFactory = sf;
    }
	public Lexer(ComplexSymbolFactory sf, java.io.Reader reader){
		this(reader);
        symbolFactory = sf;
    }
    
    private StringBuffer sb;
    private ComplexSymbolFactory symbolFactory;
    private int csline,cscolumn;

    public Symbol symbol(String name, int code){
		return symbolFactory.newSymbol(name, code,
						new Location(yyline+1,yycolumn+1, yychar), // -yylength()
						new Location(yyline+1,yycolumn+yylength(), yychar+yylength())
				);
    }
    public Symbol symbol(String name, int code, Object lexem){
	    return symbolFactory.newSymbol(name, code, 
						new Location(yyline+1, yycolumn +1, yychar), 
						new Location(yyline+1,yycolumn+yylength(), yychar+yylength()), lexem);
    }

    // private Symbol symbol(String name, int sym, Object val,int buflength) {
    //       Location left = new Location(yyline+1,yycolumn+yylength()-buflength,yychar+yylength()-buflength);
    //       Location right= new Location(yyline+1,yycolumn+yylength(), yychar+yylength());
    //       return symbolFactory.newSymbol(name, sym, left, right,val);
    // }
    
    protected void emit_warning(String message){
    	System.out.println("scanner warning: " + message + " at : 2 "+ 
    			(yyline+1) + " " + (yycolumn+1) + " " + yychar);
    }
    
    protected void emit_error(String message){
    	System.out.println("scanner error: " + message + " at : 2" + 
    			(yyline+1) + " " + (yycolumn+1) + " " + yychar);
    }
%}

// %eofval{
//      return symbolFactory.newSymbol("EOF", EOF, new Location(yyline+1,yycolumn+1,yychar), new Location(yyline+1,yycolumn+1,yychar+1));
// %eofval}
%state STRING
%%


<YYINITIAL> "if" { return symbol("if",IF); }
<YYINITIAL> "in" { return symbol("in",IN); }
<YYINITIAL> "else" { return symbol("else",ELSE); }
<YYINITIAL> "for" { return symbol("for",FOR); }
<YYINITIAL> "function" { return symbol("function",FUNCTION); }

<YYINITIAL> {

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
    {bool_literal} { return symbol("BOOLCONST",BOOLCONST, new Boolean(Boolean.parseBoolean(yytext()))); }
    // \" { string.setLength(0); yybegin(STRING); }

    {string_literal} { return symbol("STRINGCONST",STRINGCONST, yytext()); }
    {comments} {}
    {white_space} {} 

}

// <STRING> {
// \"                             {
//                                  yybegin(YYINITIAL);
//                                  return symbol("STRINGCONST",STRINGCONST, string.toString(), string.length());
//                                }

// [^\n\r\"\\]+                   { string.append( yytext() ); }
// \\t                            { string.append('\t'); }
// \\n                            { string.append('\n'); }
// \\r                            { string.append('\r'); }
// \\\"                           { string.append('\"'); }
// \\                             { string.append('\\'); }
// }

/* error fallback */
[^]                            { throw new Error("Parsing Failed! Illegal character ["+ yytext()+"] at line " + yyline + ", col " + yycolumn); }
