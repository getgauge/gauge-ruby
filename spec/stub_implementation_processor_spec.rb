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
  let(:message) {double('message')}
  context '.process_stub_implementation_code_request' do
    describe 'should return filechanges' do
      it 'should give concatenated implementations for non existent file' do
        allow(message).to receive_message_chain(:stubImplementationCodeRequest, :implementationFilePath => '')
        allow(message).to receive_message_chain(:stubImplementationCodeRequest, :codes => ['code1', 'code2'])
        allow(message).to receive(:messageId) {1}
        fileContent = subject.process_stub_implementation_code_request(message).fileChanges.fileContent
        expect(fileContent).to eq "code1\ncode2"
      end
    end
  end
end
