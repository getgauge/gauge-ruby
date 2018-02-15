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
        filePath = message.stubImplementationCodeRequest.implementationFilePath
        codes = message.stubImplementationCodeRequest.codes
        content = add_stub_impl_code_to_file_content(filePath, codes)
        r = Messages::FileChanges.new(:fileName => filePath, :fileContent => content)
        Messages::Message.new(:messageType => Messages::Message::MessageType::FileChanges, :messageId => message.messageId, :fileChanges => r)
      end

      def add_stub_impl_code_to_file_content(filePath, codes)
        content = codes.join("\n")
        if File.file?(filePath)
            fileContent = File.read(filePath)
            content = fileContent + "\n" + content
        end
        content
      end
    end
  end