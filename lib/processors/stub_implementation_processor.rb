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

module Gauge
  module Processors
    def process_stub_implementation_code_request(message)
      file_path = message.stubImplementationCodeRequest.implementationFilePath
      codes = message.stubImplementationCodeRequest.codes
      content = File.file?(file_path) ? File.read(file_path) : ''
      span = create_span content, codes
      text_diffs = [Messages::TextDiff.new(span: span, content: codes.join("\n"))]
      file_diff = Messages::FileDiff.new(filePath: file_path, textDiffs: text_diffs)
      Messages::Message.new(messageType: Messages::Message::MessageType::FileDiff,
                            messageId: message.messageId, fileDiff: file_diff)
    end

    def create_span(content, codes)
      unless content.empty?
        eof_char = content.strip.length == content.length ? "\n" : ''
        codes.unshift(eof_char)
        line = content.split("\n").length
        return Messages::Span.new(start: line, startChar: 0, end: line, endChar: 0)
      end
      Messages::Span.new(start: 0, startChar: 0, end: 0, endChar: 0)
    end
  end
end
