module transpiler

import lexer { Token, TokenType }

fn check_operator(tokens []Token, index int, operator Token, left_acceptable []TokenType, right_acceptable []TokenType) {
        left := tokens[index - 1]

        right := tokens[index + 1]

        if operator.token_type in [left.token_type, right.token_type] {
                panic("Syntax error: Can't use ${operator.token_type} as either left or right operand at ${tokens[index].line}")
        }

        // More detailed errors

        operand_syntax_error := "Can't use object as left or right operand for ${operator.token_type} at ${operator.line}"

        if left.token_type in [.identifier, .object, .plus, .minus, .multiply, .divide, .equals] {
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
                                        panic('Syntax error: Expected field name after field type at ${token.line} ${tokens[i]} ${tokens[
                                                i + 1]}')
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

                                for index <= i {
                                        if tokens[index].token_type == .field_type {
                                                if tokens[index].value == 'string' {
                                                        panic('Syntax error: Type mismatch, variable of type string cannot have a non-string value. Did you mean "${tokens[i].value}"? on line ${token.line}')
                                                }

                                                break
                                        }

                                        index -= 1
                                }
                        }

						.value_string {

							 mut index := i

                                for index <= i {
                                        if tokens[index].token_type == .field_type {
                                                if tokens[index].value != "string" {
                                                        panic('Syntax error: Type mismatch, variable of type ${tokens[index].value} cannot have a string value. Did you mean ${tokens[i].value}? on line ${token.line}')
                                                }

                                                break
                                        }

                                        index -= 1
                                }
								
						}
                        else {}
                }
        }
}

pub fn transpile(tokens []Token) {
	mut output := ""
	for i, token in tokens {
			match token.token_type  {
				.object {
					output += "public final class "
				}
				.identifier {
					output += "${token.value} "
				}

				.field_type {
					output += "${token.value} "
				}

				.field_identifier {
					output += "${token.value} "
				}

				.left_brace {
					output += "{ \n"
				}

				.right_brace {
					output += "}"
				}
				.end {
					output += "; \n"
				}
				

				.equals {
					output += "= "
				}

				.value {
					output += "${token.value} "
				}

				.value_string {
					output += '"${token.value}" '
				}

				.plus {
					output += "+ "
				}

				.minus {
					output += "- "
				}

				.multiply {
					output += "* "
				}
				.divide {
					output += "/ "
				}
				
			}
	}

	return output
}