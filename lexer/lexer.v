module lexer

import os

enum TokenType {
	left_brace
	right_brace
	object
	identifier
	field_identifier
	equals
	end
	value
	plus
	minus
	multiply
	divide
	field_type
}

struct Token {
	token_type TokenType

	value string
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

	for line in lines {
		println(line)

		if line != '' {
			for word in line.split(' ') {
				match word {
					'object' {
						tokens << Token{
							token_type: .object
							value: 'object'
						}
					}
					'int' {
						tokens << Token{
							token_type: .field_type
							value: 'int'
						}
					}
					'string' {
						tokens << Token{
							token_type: .field_type
							value: 'string'
						}
					}
					'bool' {
						tokens << Token{
							token_type: .field_type
							value: 'bool'
						}
					}
					'float' {
						tokens << Token{
							token_type: .field_type
							value: 'float'
						}
					}
					'double' {
						tokens << Token{
							token_type: .field_type
							value: 'double'
						}
					}
					'=' {
						tokens << Token{
							token_type: .equals
							value: '='
						}
					}
					'+' {
						tokens << Token{
							token_type: .plus
							value: '+'
						}
					}
					'-' {
						tokens << Token{
							token_type: .minus
							value: '-'
						}
					}
					'*' {
						tokens << Token{
							token_type: .multiply
							value: '*'
						}
					}
					'/' {
						tokens << Token{
							token_type: .divide
							value: '/'
						}
					}
					'{' {
						tokens << Token{
							token_type: .left_brace
							value: '{'
						}
					}
					'}' {
						tokens << Token{
							token_type: .right_brace
							value: '}'
						}
					}
					else {
						match tokens.last().token_type {
							.left_brace {
								tokens << Token{
									token_type: .field_type
									value: word
								}
							}
							.object {
								tokens << Token{
									token_type: .identifier
									value: word
								}
							}
							.plus {
								tokens << Token{
									token_type: .value
									value: word
								}
							}

							.minus {
								tokens << Token{
									token_type: .value
									value: word
								}
							}

							.multiply {
								tokens << Token{
									token_type: .value
									value: word
								}
							}

							.divide {
								tokens << Token{
									token_type: .value
									value: word
								}
							}

							.equals {
								if line.contains('"') {
									tokens << Token{
										token_type: .value
										value: line.substr(line.index_u8('"'.bytes()[0]) + 1,
											line.last_index_u8('"'.bytes()[0]))
									}
								} else {
									tokens << Token{
										token_type: .value
										value: word
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
