module transpiler

import lexer { Token, TokenType }

fn check_operator(tokens []Token, index int, operator Token, left_acceptable []TokenType, right_acceptable []TokenType) {
	left := tokens[index - 1]

	right := tokens[index + 1]

	if operator.token_type in [left.TokenType, right.TokenType] {
		panic("Syntax error: Can't use ${operator.token_type} as either left or right operand at ${tokens[index].line}")
	}

	// More detailed errors 

	operand_syntax_error := "Can't use object as left or right operand for ${operator.token_type} at ${operator.line}"

	if left.TokenType in [.identifier, .object, .plus, .minus, .multiply, .divide, .equals] {
		panic(operand_syntax_error)
	}

	if !left_acceptable.contains(left.token_type) {
		panic('Invalid left operand for ${operator.token_type} at ${operator.line}')
	}

	if !right_acceptable.contains(right.token_type) {
		panic('Invalid right operand for ${operator.token_type} at ${operator.line}')
	}
}

pub fn check_errors(tokens []Token) {
	for i, token in tokens {
		match token.token_type {
			// operator checks
			.equals {
				check_operator(tokens, i, token, [TokenType.field_identifier], [
					TokenType.field_identifier,
					TokenType.value,
					TokenType.value_string,
				])
			}
			.plus {
				check_operator(tokens, i, token, [TokenType.value, TokenType.value_string,
					TokenType.field_identifier], [TokenType.value, TokenType.value_string,
					TokenType.field_identifier])
			}
			.minus {
				check_operator(tokens, i, token, [TokenType.value, TokenType.value_string,
					TokenType.field_identifier], [TokenType.value, TokenType.value_string,
					TokenType.field_identifier])
			}
			.divide {
				check_operator(tokens, i, token, [TokenType.value, TokenType.value_string,
					TokenType.field_identifier], [TokenType.value, TokenType.value_string,
					TokenType.field_identifier])
			}
			.multiply {
				check_operator(tokens, i, token, [TokenType.value, TokenType.value_string,
					TokenType.field_identifier], [TokenType.value, TokenType.value_string,
					TokenType.field_identifier])
			}
			.field_type {
				if tokens[i + 1].token_type != TokenType.field_identifier {
					panic('Syntax error: Expected field name after field type at ${token.line}')
				}
			}
			.field_identifier {
				if tokens[i + 1].token_type != TokenType.equals {
					panic('Syntax error: Expected equals after field identifier at ${token.line}')
				}
			}
			.object {
				if tokens[i + 1].token_type != TokenType.identifier {
					panic('Syntax error: Expected object name  after object at ${token.line}')
				}

		
			}
			.identifier {
				if tokens[i + 1].token_type != TokenType.left_brace {
					panic('Syntax error: Expected left brace after object name at ${token.line}')
				}
			}
			.value {
				mut index := i

				mut valueType := ''

				for index <= i {
					if tokens[index].token_type == .field_type {
						valueType = tokens[index].value
					} else {
						if valueType == '' {
							panic('Syntax error: Expected field type before value assingment at ${token.line}')
						}
					}

					index -= 1
				}


				// might be a little bit dumb, my brain doesn't work rn
				if valueType == 'string' {
					if tokens[i].token_type != .value_string {
						panic('Syntax error: Expected string value after string field type at ${token.line}')
					}
				} else {
					if tokens[i].token_type == .value_string {
						panic('Syntax error: Expected non-string value after non-string field type at ${token.line}')
					}

					if tokens[i].token_type != .value {
						panic('Syntax error: Expected value after field type at ${token.line}')
					}
				}
			}
			else {}
		}
	}
}
