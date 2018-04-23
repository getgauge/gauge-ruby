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

require_relative '../code_parser'

module Gauge
  module Processors
    def refactor_step(message)
      request = message.refactorRequest
      response = refactor_response(request)
      Messages::Message.new(messageType: :RefactorResponse, messageId: message.messageId, refactorResponse: response)
    end

    def refactor_response(request)
      response = Messages::RefactorResponse.new(success: true)
      begin
        step_info = get_step request.oldStepValue.stepValue
        refactored_info = CodeParser.refactor step_info, request.paramPositions, request.newStepValue
        file = step_info[:locations][0][:file]
        File.write file, refactored_info.content if request.saveChanges
        response.filesChanged.push(file)
        changes = Messages::FileChanges.new(fileName: file, fileContent: refactored_info[:content], diffs: refactored_info[:diffs])
        response.fileChanges.push(changes)
      rescue Exception => e
        response.success = false
        response.error = e.message
      end
      response
    end

    def get_step(step_text)
      md = MethodCache.multiple_implementation? step_text
      raise "Multiple step implementations found for => '#{step_text}'" if md
      MethodCache.get_step_info(step_text)
    end
  end
end
