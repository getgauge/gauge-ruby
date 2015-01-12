require 'parser/current'
require 'unparser'

module Gauge
	class CodeParser
		def self.step_args_from_code(code)
			ast=code_to_ast(code)
			arg_node = ast.children[1]
			arg_node.children
		end

		def self.refactor_args(code, param_positions, new_param_values)
			new_params = []
			param_positions.sort_by!(&:newPosition).each { |e|
				new_params[e.newPosition-1] = new_param_values[e.newPosition-1]
			}

			buffer = Parser::Source::Buffer.new '(rewriter)'
			buffer.source=code
			
			ast = code_to_ast(code)

			Parser::Source::Rewriter.new(buffer)
				.remove(ast.children[1].location.expression) #remove existing arguments
				.insert_after(ast.children[1].location.expression, "|#{new_params.join(', ')}|") #insert new arguments
				.process
		end
		
		private
		def self.code_to_ast(code)
			buffer = Parser::Source::Buffer.new '(string)'
			buffer.source=code

			parser = Parser::CurrentRuby.new
			parser.parse(buffer)
		end

	end
end