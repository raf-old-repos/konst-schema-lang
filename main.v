import lexer  { lex_file }
import transpiler { check_errors, transpile}
import os { write_file }

fn main() {
	

	tokens  := lex_file("test.knst")

	



	check_errors(tokens)


	output := transpile(tokens)

	println(output)


	write_file("Constants.java", output) or {
		panic("Damn")
	}


	



	




	
}