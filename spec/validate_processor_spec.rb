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
