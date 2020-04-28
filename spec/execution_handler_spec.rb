=begin
 *  Copyright (c) ThoughtWorks, Inc.
 *  Licensed under the Apache License, Version 2.0
 *  See LICENSE.txt in the project root for license information.
=end
describe ExecutionHandler do
  describe '.execution_handler' do
    # let(:message) {double('message')}
    let(:exception) {double('exception')}
    context 'on failure' do
      before {
        allow(ExecutionHandler).to receive(:get_code_snippet).and_return("11 | assert_equal(expected_count.to_i, 4)\n")
        allow(exception).to receive(:message) {"error message"}
        allow(exception).to receive_message_chain(:backtrace, :select, :join => '/abc/xyz/gauge-ruby/step_implementations/step_implementation.rb:11:in block in <top (required)>')
      }
      it do
        response = subject.handle_failure(exception, ((Time.now-Time.now) * 1000).round, false)
        expect(response.executionResult.failed).to eq true
        expect(response.executionResult.errorMessage).to eq "error message"
        expect(response.executionResult.stackTrace).to eq "\n> 11 | assert_equal(expected_count.to_i, 4)\n/abc/xyz/gauge-ruby/step_implementations/step_implementation.rb:11:in block in <top (required)>\n"
      end
    end

    context 'on failure for windows filepath' do
      before {
        allow(ExecutionHandler).to receive(:get_code_snippet).and_return("11 | assert_equal(expected_count.to_i, 4)\n")
        allow(exception).to receive(:message) {"error message"}
        allow(exception).to receive_message_chain(:backtrace, :select, :join => 'C:/abc/xyz/gauge-ruby/step_implementations/step_implementation.rb:11:in block in <top (required)>')
      }
      it {
        ENV['GAUGE_PROJECT_ROOT'] = 'C:/'
        response = subject.handle_failure(exception, ((Time.now-Time.now) * 1000).round, false)
        expect(response.executionResult.failed).to eq true
        expect(response.executionResult.errorMessage).to eq "error message"
        expect(response.executionResult.stackTrace).to eq "\n> 11 | assert_equal(expected_count.to_i, 4)\nC:/abc/xyz/gauge-ruby/step_implementations/step_implementation.rb:11:in block in <top (required)>\n"
        ENV['GAUGE_PROJECT_ROOT'] = "/temp"
      }
    end

    context 'on success' do
      before {
        allow(ExecutionHandler).to receive(:get_code_snippet).and_return("29 | assert_fail_assertion()\n")
      }
      it {
        response = subject.handle_pass(((Time.now-Time.now) * 1000).round)
        expect(response.executionResult.failed).to eq false
      }
    end

  end
end

