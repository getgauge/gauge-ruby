=begin
 *  Copyright (c) ThoughtWorks, Inc.
 *  Licensed under the Apache License, Version 2.0
 *  See LICENSE.txt in the project root for license information.
=end
describe Gauge::Processors do
  let(:given_block) { -> { puts "foo" } }
  let(:step_validation_request) { double("request") }
  context ".process_step_validation_request" do
    describe "should return valid response" do
      before {
        Gauge::MethodCache.add_step "step_text1", { block: given_block }
        allow(step_validation_request).to receive(:stepText).and_return("step_text1")
        allow(step_validation_request).to receive(:messageId) { 1 }
      }
      it "should get registered <block>" do
        expect(subject.process_step_validation_request(step_validation_request).isValid).to eq true
      end
    end

    describe "should return error response when duplicate step impl" do
      before {
        Gauge::MethodCache.add_step "step_text2", { block: given_block }
        Gauge::MethodCache.add_step "step_text2", { block: given_block }
        allow(step_validation_request).to receive(:stepText).and_return("step_text2")
      }
      it {
        response = subject.process_step_validation_request(step_validation_request)
        expect(response.isValid).to eq false
        expect(response.errorMessage).to eq "Multiple step implementations found for => 'step_text2'"
      }
    end

    describe "should return error response when no step impl" do
      before {
        allow(step_validation_request).to receive_message_chain(:stepValue, :stepValue => "step_text3 {}")
        allow(step_validation_request).to receive_message_chain(:stepValue, :parameterizedStepValue => "step_text3 <hello>")
        allow(step_validation_request).to receive_message_chain(:stepValue, :parameters => ["hello"])
        allow(step_validation_request).to receive_message_chain(:stepText, "step_text3 {}")
      }
      it {
        expected_suggestion = "step 'step_text3 <arg0>' do |arg0|\n\traise 'Unimplemented Step'\nend"
        response = subject.process_step_validation_request(step_validation_request)
        expect(response.isValid).to eq false
        expect(response.errorMessage).to eq "Step implementation not found"
        expect(response.suggestion).to eq expected_suggestion
      }
    end
  end
end
