import lexer  { lex_file }
import transpiler { check_errors, transpile}

fn main() {
	

	tokens  := lex_file("test.knst")

	



	check_errors(tokens)


	output := transpile(tokens)


	



	




	
}