# Copyright 2015 ThoughtWorks, Inc.

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

describe ExecutionHandler do
  describe '.execution_handler' do
    let(:message) {double('message')}
    let(:exception) {double('exception')}
    context 'on failure' do
      before {
        allow(ExecutionHandler).to receive(:get_code_snippet).and_return("11 | assert_equal(expected_count.to_i, 4)\n")
        allow(message).to receive(:messageId) {1}
        allow(exception).to receive(:message) {"error message"}
        allow(exception).to receive_message_chain(:backtrace, :select, :join => '/abc/xyz/gauge-ruby/step_implementations/step_implementation.rb:11:in block in <top (required)>')
      }
      it {
        response = subject.handle_failure(message, exception, ((Time.now-Time.now) * 1000).round, false).executionStatusResponse
        expect(response.executionResult.failed).to eq true
        expect(response.executionResult.errorMessage).to eq "error message"
        expect(response.executionResult.stackTrace).to eq "> 11 | assert_equal(expected_count.to_i, 4)\n/abc/xyz/gauge-ruby/step_implementations/step_implementation.rb:11:in block in <top (required)>\n"
      }
    end

    context 'on failure in windows' do
      before {
        allow(ExecutionHandler).to receive(:get_code_snippet).and_return("11 | assert_equal(expected_count.to_i, 4)\n")
        allow(message).to receive(:messageId) {1}
        allow(exception).to receive(:message) {"error message"}
        allow(exception).to receive_message_chain(:backtrace, :select, :join => 'C:/abc/xyz/gauge-ruby/step_implementations/step_implementation.rb:11:in block in <top (required)>')
      }
      it {
        response = subject.handle_failure(message, exception, ((Time.now-Time.now) * 1000).round, false).executionStatusResponse
        expect(response.executionResult.failed).to eq true
        expect(response.executionResult.errorMessage).to eq "error message"
        expect(response.executionResult.stackTrace).to eq "> 11 | assert_equal(expected_count.to_i, 4)\nC:/abc/xyz/gauge-ruby/step_implementations/step_implementation.rb:11:in block in <top (required)>\n"
      }
    end

    context 'on success' do
      before {
        allow(ExecutionHandler).to receive(:get_code_snippet).and_return("29 | assert_fail_assertion()\n")
        allow(message).to receive(:messageId) {1}
      }
      it {
        response = subject.handle_pass(message, ((Time.now-Time.now) * 1000).round).executionStatusResponse
        expect(response.executionResult.failed).to eq false
      }
    end

  end
end

