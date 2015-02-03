require 'parser/current'
require 'method_source'
require 'fileutils'
require 'tempfile'

module Gauge
  class CodeParser
    def self.step_args_from_code(code)
      ast=code_to_ast(code)
      arg_node = ast.children[1]
      arg_node.children
    end

    def self.refactor_args(code, param_positions, new_param_values, new_step_text)
      new_params = []
      args = step_args_from_code code
      param_positions.sort_by!(&:newPosition).each { |e|
        if e.oldPosition == -1
          new_params[e.newPosition] = new_param_values[e.newPosition]
        else
          new_params[e.newPosition] = args[e.oldPosition].children[0]
        end
      }
      buffer = Parser::Source::Buffer.new '(rewriter)'
      buffer.source=code
      
      ast = code_to_ast(code)
      new_params_string = "|#{new_params.join(', ')}|".gsub("||", "") # no params = empty string
      
      rewriter = Parser::Source::Rewriter.new(buffer)
        .replace(ast.children[0].location.expression, "step '#{new_step_text}'")
      
      # hack, could not find an easy way to manipulate the ast to include arguments, when none existed originally.
      # it's just easy to add arguments via string substitution.
      return include_args(rewriter.process, new_params_string) if ast.children[1].location.expression.nil?
      
      rewriter.replace(ast.children[1].location.expression, new_params_string) #insert new arguments
        .process
    end

    def self.refactor(code, param_positions, new_param_values, new_step_text)
      source_code=code.source
      ast = code_to_ast source_code
      file, line = code.source_location
      refactored_code=refactor_args(source_code, param_positions, new_param_values, new_step_text)
      tmp_file = Tempfile.new File.basename(file, ".rb")
      tmp_file.write(File.open(file, "r") { |f| f.read.gsub(source_code, refactored_code)})
      tmp_file.close
      FileUtils.mv tmp_file.path, file
    end

    private

    def self.code_to_ast(code)
      buffer = Parser::Source::Buffer.new '(string)'
      buffer.source = code

      parser = Parser::CurrentRuby.new
      parser.parse(buffer)
    end

    def self.include_args(code_string, params)
      code_string.gsub("do", "do #{params}")
    end
  end
end