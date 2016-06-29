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

module Gauge
  module Processors
    def process_step_validation_request(message)
      step_validate_request = message.stepValidateRequest
      is_valid = true
      msg = ''
      err_type = nil
      blocks = MethodCache.get_steps(step_validate_request.stepText)
      if blocks.length > 1
        is_valid = false
        msg = "Multiple step implementations found for => '#{step_validate_request.stepText}'"
        err_type = Messages::StepValidateResponse::ErrorType::DUPLICATE_STEP_IMPLEMENTATION
      elsif blocks.length == 0
        is_valid = false
        msg = 'Step implementation not found'
        err_type = Messages::StepValidateResponse::ErrorType::STEP_IMPLEMENTATION_NOT_FOUND
      end
      step_validate_response = Messages::StepValidateResponse.new(:isValid => is_valid, :errorMessage => msg, :errorType => err_type)
      Messages::Message.new(:messageType => Messages::Message::MessageType::StepValidateResponse,
        :messageId => message.messageId, 
        :stepValidateResponse => step_validate_response)
    end
  end
end