module lexer

import os

pub enum TokenType {
	left_brace
	right_brace
	object
	identifier
	field_identifier
	equals
	end
	value
	value_string
	plus
	minus
	multiply
	divide
	field_type
}

pub struct Token {
	pub: 
		
		token_type TokenType

		value string

		line  int
}

pub fn lex_file(path string) []Token {
	lines := os.read_lines(path) or {
		println('Error: File not found')

		return []
	}

	return lex(lines)
}

pub fn lex(lines []string) []Token {
	mut tokens := []Token{}

	println(lines)

	for i, line in lines {
		println(line)

		indx := i + 1

		if line != '' {
			for word in line.split(' ') {
				match word {
					'object' {
						tokens << Token{
							token_type: .object
							value: 'object'
							line: indx
						}
					}
					'int' {
						tokens << Token{
							token_type: .field_type
							value: 'int'
							line: indx
						}
					}
					'string' {
						tokens << Token{
							token_type: .field_type
							value: 'string'
							line: indx
						}
					}
					'bool' {
						tokens << Token{
							token_type: .field_type
							value: 'bool'
							line: indx
						}
					}
					'float' {
						tokens << Token{
							token_type: .field_type
							value: 'float'
							line: indx
						}
					}
					'double' {
						tokens << Token{
							token_type: .field_type
							value: 'double'
							line: indx
						}
					}
					'=' {
						tokens << Token{
							token_type: .equals
							value: '='
							line: indx
						}
					}
					'+' {
						tokens << Token{
							token_type: .plus
							value: '+'
							line: indx
						}
					}
					'-' {
						tokens << Token{
							token_type: .minus
							value: '-'
							line: indx
						}
					}
					'*' {
						tokens << Token{
							token_type: .multiply
							value: '*'
							line: indx
						}
					}
					'/' {
						tokens << Token{
							token_type: .divide
							value: '/'
							line: indx
						}
					}
					'{' {
						tokens << Token{
							token_type: .left_brace
							value: '{'
							line: indx
						}
					}
					'}' {
						tokens << Token{
							token_type: .right_brace
							value: '}'
							line: indx
						}
					}
					else {
						match tokens.last().token_type {
							.left_brace {
								tokens << Token{
									token_type: .field_type
									value: word
									line: indx
								}
							}
							.object {
								tokens << Token{
									token_type: .identifier
									value: word
									line: indx
								}
							}
							.plus {
								tokens << Token{
									token_type: .value
									value: word
									line: indx
								}
							}

							.minus {
								tokens << Token{
									token_type: .value
									value: word
									line: indx
								}
							}

							.multiply {
								tokens << Token{
									token_type: .value
									value: word
									line: indx
								}
							}

							.divide {
								tokens << Token{
									token_type: .value
									value: word
									line: indx
								}
							}

							.equals {
								if line.contains('"') {
									tokens << Token{
										token_type: .value_string
										value: line.substr(line.index_u8('"'.bytes()[0]) + 1,
											line.last_index_u8('"'.bytes()[0]))
										line: indx
									}
								} else {
									tokens << Token{
										token_type: .value
										value: word
										line: indx
									}
								}
							}
							else {
								continue
							}
						}
					}
				}
			}

			tokens << Token{
				token_type: .end
				value: 'end'
				line: indx
			}
		}
	}

	// clean tokens
	for i, token in tokens {
		if token.token_type == .end {
			match tokens[i - 1].token_type {
				.identifier {
					tokens.delete(i)
				}
				.end {
					tokens.delete(i)
				}
				.field_type {
					tokens.delete(i)
				}
				.field_identifier {
					tokens.delete(i)
				}
				.equals {
					tokens.delete(i)
				}
				.left_brace {
					tokens.delete(i)
				}

				
				else {
					continue
				}
			}
		}
	}

	return tokens
}
