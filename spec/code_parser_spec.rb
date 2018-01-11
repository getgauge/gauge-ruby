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

describe Gauge::CodeParser do

  describe 'self.step_args_from_code' do
    let(:code_block) { "step \"say <what> to <who>\" do |what, who|\n\tp what + who\nend" }
    let(:code_block_without_args) { "step \"say foo\" do \n\tp \"foo\"end" }

    it 'gets arguments from code block' do
      args = described_class.step_args_from_code(code_block)
      expect(args.to_s).to eq '[s(:arg, :what), s(:arg, :who)]'
    end

    it 'gets empty args from code block without args' do
      args = described_class.step_args_from_code(code_block_without_args)
      expect(args.to_s).to eq '[]'
    end
  end

  describe 'self.refactor_args' do
    before(:each) do
      Gauge::MethodCache.clear
      @parsed_step = 'say {} to {}'
      @parsed_step_no_args = 'say hello'

      allow(Gauge::Connector).to receive(:step_value).with('say <what> to <who>').and_return(@parsed_step)
      allow(Gauge::Connector).to receive(:step_value).with('say hello').and_return(@parsed_step_no_args)

      step 'say <what> to <who>' do |what, who|
        puts "say #{what} to #{who}"
      end

      step 'say hello' do
        puts 'say hello'
      end
    end

    let(:source_code) {Gauge::MethodCache.get_step(@parsed_step).source}
    let(:source_code_no_args) {Gauge::MethodCache.get_step(@parsed_step_no_args).source}

    it 'replaces step text' do
      new_step_text='new step text'
      refactored_code = described_class.refactor_args(source_code, [], [], new_step_text)
      refactored_code_ast = described_class.code_to_ast(refactored_code)
      refactored_step_text = refactored_code_ast.children[0].children[2].children[0]
      expect(refactored_step_text).to eq new_step_text
    end

    it 'reorders arguments' do
      param_positions=[Gauge::Messages::ParameterPosition.new(oldPosition: 1, newPosition: 0), Gauge::Messages::ParameterPosition.new(oldPosition: 0, newPosition: 1)]
      refactored_code = described_class.refactor_args(source_code, param_positions, %w(who what), 'say <who> to <what>')
      new_args = described_class.step_args_from_code(refactored_code)
      expect(new_args.to_s).to eq '[s(:arg, :who), s(:arg, :what)]'
    end

    it 'removes arguments' do
      param_positions=[Gauge::Messages::ParameterPosition.new(oldPosition: 1, newPosition: 0)]
      refactored_code = described_class.refactor_args(source_code, param_positions, ['who'], 'say <who>')
      new_args = described_class.step_args_from_code(refactored_code)
      expect(new_args.to_s).to eq '[s(:arg, :who)]'
    end

    it 'inserts arguments' do
      param_positions=[Gauge::Messages::ParameterPosition.new(oldPosition: 0, newPosition: 0),
                       Gauge::Messages::ParameterPosition.new(oldPosition: -1, newPosition: 1),
                       Gauge::Messages::ParameterPosition.new(oldPosition: 1, newPosition: 2)]
      refactored_code = described_class.refactor_args(source_code, param_positions, %w(what where who), 'say <what> to <who> at <where>')
      new_args = described_class.step_args_from_code(refactored_code)
      expect(new_args.to_s).to eq '[s(:arg, :what), s(:arg, :arg_where), s(:arg, :who)]'
    end

    it 'inserts arguments when none existed' do
      param_positions=[Gauge::Messages::ParameterPosition.new(oldPosition: -1, newPosition: 0), Gauge::Messages::ParameterPosition.new(oldPosition: -1, newPosition: 1)]
      refactored_code = described_class.refactor_args(source_code_no_args, param_positions, %w(what who), 'say <what> to <who>')
      new_args = described_class.step_args_from_code(refactored_code)
      expect(new_args.to_s).to eq '[s(:arg, :arg_what), s(:arg, :arg_who)]'
      end

    it 'inserts arguments with keywords' do
      param_positions=[Gauge::Messages::ParameterPosition.new(oldPosition: -1, newPosition: 0)]
      refactored_code = described_class.refactor_args(source_code_no_args, param_positions, ['1'], 'say <1>')
      new_args = described_class.step_args_from_code(refactored_code)
      expect(new_args.to_s).to eq '[s(:arg, :arg_1)]'
    end

    it 'ignores special characters in param names' do
      param_positions=[Gauge::Messages::ParameterPosition.new(oldPosition: -1, newPosition: 0), Gauge::Messages::ParameterPosition.new(oldPosition: -1, newPosition: 1)]
      refactored_code = described_class.refactor_args(source_code_no_args, param_positions, %w(what@ who&1), 'say <what@> to <who&1>')
      new_args = described_class.step_args_from_code(refactored_code)
      expect(new_args.to_s).to eq '[s(:arg, :arg_what), s(:arg, :arg_who1)]'
    end

    it 'adds param index to param name if it only has a special character' do
      param_positions=[Gauge::Messages::ParameterPosition.new(oldPosition: -1, newPosition: 0), Gauge::Messages::ParameterPosition.new(oldPosition: -1, newPosition: 1)]
      refactored_code = described_class.refactor_args(source_code_no_args, param_positions, %w(@ *), 'say <@> to <*>')
      new_args = described_class.step_args_from_code(refactored_code)
      expect(new_args.to_s).to eq '[s(:arg, :arg_0), s(:arg, :arg_1)]'
    end
  end
end
