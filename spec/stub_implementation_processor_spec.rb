=begin
 *  Copyright (c) ThoughtWorks, Inc.
 *  Licensed under the Apache License, Version 2.0
 *  See LICENSE.txt in the project root for license information.
=end
describe Gauge::Processors do
  let(:stub_impl_code_request) { double('request') }
  context '.process_stub_implementation_code_request' do
    describe 'should return filechanges' do
      it 'should give concatenated implementations for non existent file' do
        allow(stub_impl_code_request).to receive_messages(implementationFilePath: '', codes: ['code1', 'code2'])

        ENV['GAUGE_PROJECT_ROOT'] = Dir.pwd
        span = Gauge::Messages::Span.new(start: 0, end: 0, startChar: 0, endChar: 0)
        text_diff = Gauge::Messages::TextDiff.new(span: span, content: "code1\ncode2")
        response = subject.process_stub_implementation_code_request(stub_impl_code_request)

        expect(response.textDiffs[0]).to eq text_diff
        expect(File.basename(response.filePath)).to eq 'step_implementation.rb'
      end
    end
  end
end
