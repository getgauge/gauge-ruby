require 'rspec'
require_relative '../lib/code_parser.rb'
require_relative '../lib/gauge-ruby.rb'
require_relative '../lib/messages.pb.rb'

describe Gauge::CodeParser do

	describe "self.step_args_from_code" do
		let(:code_block) { "step \"say <what> to <who>\" do |what, who|\n\tp what + who\nend" }
		let(:code_block_without_args) { "step \"say foo\" do \n\tp \"foo\"end" }

		it "gets arguments from code block" do
			args = described_class.step_args_from_code(code_block)
			expect(args.to_s).to eq "[(arg :what), (arg :who)]"
		end

		it "gets empty args from code block without args" do
			args = described_class.step_args_from_code(code_block_without_args)
			expect(args.to_s).to eq "[]"
		end
	end

	describe "self.refactor" do
		before(:each) do
			@parsed_step = "say {} to {}"
			allow(Connector).to receive(:step_value).and_return(@parsed_step)
			step "say <what> to <who>" do |what, who|
				puts "say #{what} to #{who}"
			end
		end

		it "replaces step text" do
			new_step_text="new step text"
			refactored_code = described_class.refactor($steps_map[@parsed_step], [], ["who", "what"], new_step_text)
			refactored_code_ast = described_class.code_to_ast(refactored_code)
			refactored_step_text = refactored_code_ast.children[0].children[2].children[0]
			expect(refactored_step_text).to eq new_step_text
		end

		it "reorders arguments" do
			param_positions=[Main::ParameterPosition.new(oldPosition: 2, newPosition: 1), Main::ParameterPosition.new(oldPosition: 1, newPosition: 2)]
			refactored_code = described_class.refactor($steps_map[@parsed_step], param_positions, ["who", "what"], "say <who> to <what>")
			new_args = described_class.step_args_from_code(refactored_code)
			expect(new_args.to_s).to eq "[(arg :who), (arg :what)]"
		end

		it "removes arguments" do
			param_positions=[Main::ParameterPosition.new(oldPosition: 2, newPosition: 1)]
			refactored_code = described_class.refactor($steps_map[@parsed_step], param_positions, ["who"], "say <who>")
			new_args = described_class.step_args_from_code(refactored_code)
			expect(new_args.to_s).to eq "[(arg :who)]"
		end

		it "inserts arguments" do
			param_positions=[Main::ParameterPosition.new(oldPosition: 1, newPosition: 1), 
				Main::ParameterPosition.new(oldPosition: -1, newPosition: 2),
				Main::ParameterPosition.new(oldPosition: 2, newPosition: 3)]
			refactored_code = described_class.refactor($steps_map[@parsed_step], param_positions, ["what", "where", "who"], "say <what> to <who> at <where>")
			new_args = described_class.step_args_from_code(refactored_code)
			expect(new_args.to_s).to eq "[(arg :what), (arg :where), (arg :who)]"
		end

		it "replaces step text" do
			param_positions=[Main::ParameterPosition.new(oldPosition: 2, newPosition: 1)]
			refactored_code = described_class.refactor($steps_map[@parsed_step], param_positions, ["who"], "say <who>")
			new_args = described_class.step_args_from_code(refactored_code)
			expect(new_args.to_s).to eq "[(arg :who)]"
		end
	end
end