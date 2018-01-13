# Copyright 2018 ThoughtWorks, Inc.

# This file is part of Gauge-Ruby.

# Gauge-Ruby is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.

# Gauge-Ruby is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with Gauge-Ruby.  If not, see <http://www.gnu.org/licenses/>.

require_relative 'gauge'
require_relative 'code_parser'
require_relative 'method_cache'

module Gauge
  # @api private
  module StaticLoader
    def self.load_files(dir)
      Dir["#{dir}/**/*.rb"].each do |x|
        load_steps(x, CodeParser.code_to_ast(File.read(x)))
      end
    end

    def self.traverse(ast, &visitor)
      return if ast.class != Parser::AST::Node
      if ast && step_node?(ast)
        visitor.call(ast)
      elsif ast&.children
        ast.children.each {|node|
          traverse(node, &visitor)
        }
      end
    end

    def self.load_steps(file, ast)
      traverse ast do |node|
        process_node(file, node)
      end
    end

    def self.reload_steps(file, ast)
      return unless ast
      remove_steps file
      load_steps(file, ast)
    end

    def self.remove_steps(file)
      Gauge::MethodCache.remove_steps file
    end

    def self.step_node?(node)
      node.type == :block && node.children[0].children[1] == :step
    end

    def self.process_node(file, node)
      if aliases?(node)
        load_aliases(file, node)
      else
        step_text = node.children[0].children[2].children[0]
        step_value = Gauge::Connector.step_value step_text
        load_step(file, step_value, step_text, node, {recoverable: recoverable?(node)})
      end
    end

    def self.aliases?(node)
      return node.children[0].children.size > 3 && node.children[0].children[3].type == :str
    end

    def self.load_aliases(file, node)
      recoverable = false
      if recoverable? node
        aliases = node.children[0].children.slice(2, node.children[0].children.length() - 3)
        recoverable = true
      else
        aliases = node.children[0].children.slice(2, node.children[0].children.length() - 2)
      end
      Gauge::MethodCache.add_step_alias(*aliases.map {|x| x.children[0]})
      aliases.each {|x|
        sv = Gauge::Connector.step_value x.children[0]
        load_step(file, sv, x.children[0], node, {recoverable: recoverable})
      }
    end

    def self.recoverable?(node)
      size = node.children[0].children.length
      options = node.children[0].children[size - 1]
      options.type == :hash && options.children[0].children[0].children[0] == :continue_on_failure
    end

    def self.load_step(file, step_value, step_text, block, options)
      si = {location: {file: file, span: block.loc}, step_text: step_text,
            block: block, recoverable: options[:recoverable]}
      Gauge::MethodCache.add_step(step_value, si)
    end
  end
end
