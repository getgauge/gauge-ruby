# Copyright 2014 ThoughtWorks, Inc.

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
      oldStepValue = message.refactorRequest.oldStepValue.stepValue
      newStep = message.refactorRequest.newStepValue
      stepBlock = MethodCache.get_step oldStepValue
      refactor_response = Messages::RefactorResponse.new(success: true)
      begin
        CodeParser.refactor stepBlock, message.refactorRequest.paramPositions, newStep.parameters, newStep.parameterizedStepValue
      rescue Exception => e
        refactor_response.success=false
        refactor_response.error=e.message
      end
      Messages::Message.new(:messageType => Messages::Message::MessageType::RefactorResponse, :messageId => message.messageId, refactorResponse: refactor_response)
    end
  end
end