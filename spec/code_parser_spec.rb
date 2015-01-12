require 'rspec'
require_relative '../lib/code_parser.rb'
require_relative '../lib/messages.pb.rb'

describe Gauge::CodeParser do
	let(:code_block) { "step \"say <what> to <who>\" do |what, who|\n\tp what + who\nend" }
	let(:code_block_without_args) { "step \"say foo\" do \n\tp \"foo\"end" }

	describe "self.step_args_from_code" do
		it "gets arguments from code block" do
			args = described_class.step_args_from_code(code_block)
			expect(args.to_s).to eq "[(arg :what), (arg :who)]"
		end

		it "gets empty args from code block without args" do
			args = described_class.step_args_from_code(code_block_without_args)
			expect(args.to_s).to eq "[]"
		end
	end

	describe "self.refactor_args" do
		it "reorders arguments" do
			param_positions=[Main::ParameterPosition.new(oldPosition: 2, newPosition: 1), Main::ParameterPosition.new(oldPosition: 1, newPosition: 2)]
			refactored_code = described_class.refactor_args(code_block, param_positions, ["who", "what"])
			new_args = described_class.step_args_from_code(refactored_code)
			expect(new_args.to_s).to eq "[(arg :who), (arg :what)]"
		end

		it "removes arguments" do
			param_positions=[Main::ParameterPosition.new(oldPosition: 2, newPosition: 1)]
			refactored_code = described_class.refactor_args(code_block, param_positions, ["who"])
			new_args = described_class.step_args_from_code(refactored_code)
			expect(new_args.to_s).to eq "[(arg :who)]"
		end

		it "inserts arguments" do
			param_positions=[Main::ParameterPosition.new(oldPosition: 1, newPosition: 1), 
				Main::ParameterPosition.new(oldPosition: -1, newPosition: 2),
				Main::ParameterPosition.new(oldPosition: 2, newPosition: 3)]
			refactored_code = described_class.refactor_args(code_block, param_positions, ["what", "where", "who"])
			new_args = described_class.step_args_from_code(refactored_code)
			expect(new_args.to_s).to eq "[(arg :what), (arg :where), (arg :who)]"
		end
	end	
end