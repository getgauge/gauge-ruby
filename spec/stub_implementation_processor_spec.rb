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
  let(:message) { double('message') }
  context '.process_stub_implementation_code_request' do
    describe 'should return filechanges' do
      it 'should give concatenated implementations for non existent file' do
        allow(message).to receive_message_chain(:stubImplementationCodeRequest, implementationFilePath: '')
        allow(message).to receive_message_chain(:stubImplementationCodeRequest, codes: ['code1', 'code2'])
        allow(message).to receive(:messageId) { 1 }

        ENV['GAUGE_PROJECT_ROOT'] = Dir.pwd
        span = Gauge::Messages::Span.new(start: 0, end: 0, startChar: 0, endChar: 0)
        text_diff = Gauge::Messages::TextDiff.new(span: span, content: "code1\ncode2")
        response = subject.process_stub_implementation_code_request(message)

        expect(response.fileDiff.textDiffs[0]).to eq text_diff
        expect(File.basename(response.fileDiff.filePath)).to eq 'step_implementation.rb'
      end
    end
  end
end
