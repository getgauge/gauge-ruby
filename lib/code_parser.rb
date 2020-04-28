=begin
 *  Copyright (c) ThoughtWorks, Inc.
 *  Licensed under the Apache License, Version 2.0
 *  See LICENSE.txt in the project root for license information.
=end
require 'parser/current'
require 'unparser'
require 'method_source'
require 'fileutils'
require 'tempfile'
require 'util'
require 'messages_pb'

module Gauge
  # @api private
  class CodeParser
    def self.step_args_from_code(ast)
      arg_node = ast.children[1]
      arg_node.children
    end

    def self.process_node(node, param_positions, _new_param_values, new_step_text)
      new_params = []
      args = step_args_from_code node
      old_params = args.map { |arg| Unparser.unparse arg }
      param_positions.sort_by!(&:newPosition).each.with_index do |e, i|
        if e.oldPosition == -1
          new_params[e.newPosition] = Util.get_param_name(old_params, i)
        else
          new_params[e.newPosition] = args[e.oldPosition].children[0]
        end
      end
      args = new_params.map { |v| Parser::AST::Node.new(:arg, [v]) }
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
        children = ast.children.map do |node|
          replace(node, &visitor)
        end
        return ast.updated(nil, children, nil)
      end
    end

    def self.step_node?(node)
      node.type == :block && node.children[0].children.size > 2 && node.children[0].children[1] == :step
    end

    def self.create_params_diff(old_node, new_node)
      params_loc = old_node.children[1].loc
      text = Unparser.unparse new_node.children[1]
      if old_node.children[1].children.size > 1
        span = Messages::Span.new(start: params_loc.begin.line, startChar: params_loc.begin.column + 1,
                                  end: params_loc.end.line, endChar: params_loc.end.column)
      else
        span = Messages::Span.new(start: old_node.loc.begin.line, startChar: old_node.loc.begin.column,
                                  end: old_node.children[2].loc.line, endChar: old_node.children[2].loc.column)
        text = "do#{text.empty? ? text : " |#{text}|"}\n\t"
      end
      Messages::TextDiff.new(content: text, span: span)
    end

    def self.create_diffs(old_node, new_node)
      step_loc = old_node.children[0].children[2].loc
      step_text = new_node.children[0].children[2].children[0]
      span = Messages::Span.new(start: step_loc.begin.line,
                                end: step_loc.end.line,
                                startChar: step_loc.begin.column + 1,
                                endChar: step_loc.end.column)
      [Messages::TextDiff.new(content: step_text, span: span), create_params_diff(old_node, new_node)]
    end

    def self.refactor_args(step_text, ast, param_positions, new_param_values, new_step_text)
      diffs = nil
      new_ast = replace ast do |node|
        if node.children[0].children[2].children[0] == step_text
          old_node = node.clone
          node = process_node(node, param_positions, new_param_values, new_step_text)
          diffs = create_diffs(old_node, node)
        end
          node
        end
      code = Unparser.unparse new_ast
      { content: code, diffs: diffs }
      end

    def self.refactor(step_info, param_positions, new_step)
      ast = code_to_ast File.read(step_info[:locations][0][:file])
      refactor_args(step_info[:step_text], ast, param_positions,
                    new_step.parameters,
                    new_step.parameterizedStepValue)
    end

    private_class_method

    def self.code_to_ast(code)
      begin
        buffer = Parser::Source::Buffer.new '(string)'
        buffer.source = code
        parser = Parser::CurrentRuby.new
      parser.parse(buffer)
      rescue Exception => e
        GaugeLog.error e
      end
    end
  end
end
