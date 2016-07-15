# Copyright 2015 ThoughtWorks, Inc.
#
# This file is part of Gauge-Ruby.
#
# Gauge-Ruby is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# Gauge-Ruby is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with Gauge-Ruby.  If not, see <http://www.gnu.org/licenses/>.

require 'parser/current'
require 'method_source'
require 'fileutils'
require 'tempfile'
require 'util'

module Gauge
  # @api private
  class CodeParser
    def self.step_args_from_code(code)
      ast=code_to_ast(code)
      arg_node = ast.children[1]
      arg_node.children
    end

    def self.refactor_args(code, param_positions, new_param_values, new_step_text)
      new_params = []
      args = step_args_from_code code
      param_positions.sort_by!(&:newPosition).each.with_index { |e,i|
        if e.oldPosition == -1
          param = Util.remove_special_chars new_param_values[e.newPosition].downcase.split.join('_')
          if param == ''
            param = i
          end
          new_params[e.newPosition] = "arg_#{param}"
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
      
      #insert new arguments
      rewriter.replace(ast.children[1].location.expression, new_params_string).process
    end

    def self.refactor(code, param_positions, new_param_values, new_step_text)
      source_code=code.source
      file, _ = code.source_location
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