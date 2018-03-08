# Copyright 2018 ThoughtWorks, Inc.
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
require 'unparser'
require 'method_source'
require 'fileutils'
require 'tempfile'
require 'util'

module Gauge
  # @api private
  class CodeParser
    def self.step_args_from_code(ast)
      arg_node = ast.children[1]
      arg_node.children
    end

    def self.process_node(node, param_positions, new_param_values, new_step_text)
      new_params = []
      args = step_args_from_code node
      param_positions.sort_by!(&:newPosition).each.with_index {|e, i|
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
      args = new_params.map {|v| Parser::AST::Node.new(:arg, [v])}
      step = [node.children[0].children[0], node.children[0].children[1], Parser::AST::Node.new(:str, [new_step_text])]
      c1 = Parser::AST::Node.new(:send, step)
      c2 = Parser::AST::Node.new(:args, args)
      Parser::AST::Node.new(:block, [c1, c2, node.children[2]])
    end

    def self.replace(ast, &visitor)
      return ast if ast.class != Parser::AST::Node
      if ast && step_node?(ast)
        visitor.call(ast)
      else
        children = ast.children.map {|node|
          replace(node, &visitor)
        }
        return ast.updated(nil, children, nil)
      end
    end

    def self.step_node?(node)
      node.type == :block && node.children[0].children.size > 2 && node.children[0].children[1] == :step
    end

    def self.refactor_args(step_text, ast, param_positions, new_param_values, new_step_text)
      new_ast = replace ast do |node|
        if node.children[0].children[2].children[0] == step_text
          process_node(node, param_positions, new_param_values, new_step_text)
        else
          node
        end
      end
      Unparser.unparse new_ast
    end

    def self.refactor(step_info, param_positions, new_step)
      ast = code_to_ast File.read(step_info[:locations][0][:file])
      refactor_args(step_info[:step_text], ast, param_positions, new_step.parameters, new_step.parameterizedStepValue)
    end

    private

    def self.code_to_ast(code)
      begin
        buffer = Parser::Source::Buffer.new '(string)'
        buffer.source = code
        parser = Parser::CurrentRuby.new
        return parser.parse(buffer)
      rescue Exception => e
        Gauge::Log.error e.message
      end
    end

    def self.include_args(code_string, params)
      code_string.gsub("do", "do #{params}")
    end
  end
end