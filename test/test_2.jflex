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
%{
	

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
    public Symbol symbol(String name, int code, String lexem){
	return symbolFactory.newSymbol(name, code, 
						new Location(yyline+1, yycolumn +1, yychar), 
						new Location(yyline+1,yycolumn+yylength(), yychar+yylength()), lexem);
    }
    
    protected void emit_warning(String message){
    	System.out.println("scanner warning: " + message + " at : 2 "+ 
    			(yyline+1) + " " + (yycolumn+1) + " " + yychar);
    }
    
    protected void emit_error(String message){
    	System.out.println("scanner error: " + message + " at : 2" + 
    			(yyline+1) + " " + (yycolumn+1) + " " + yychar);
    }
%}

%eofval{
     return symbolFactory.newSymbol("EOF", EOF, new Location(yyline+1,yycolumn+1,yychar), new Location(yyline+1,yycolumn+1,yychar+1));
%eofval}

%%
"if" { return symbol("if",IF); }
"in" { return symbol("in",IN); }
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
{bool_literal} { return symbol("BOOLCONST",BOOLCONST, new Boolean(Boolean.parseBoolean(yytext()))); }
{string_literal} { return symbol("STRINGCONST",STRINGCONST, yytext()); }
{comments} { return symbol("Comments",COMMENTS);}
{whitespace} { }

/* error fallback */
.|\n {  
		    error("Illegal character <"+ yytext()+">");
    }