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
      is_valid = MethodCache.valid_step?(step_validate_request.stepText)
      step_validate_response = Messages::StepValidateResponse.new(:isValid => is_valid,
        :errorMessage => is_valid ? "" : "Step implementation not found")
      Messages::Message.new(:messageType => Messages::Message::MessageType::StepValidateResponse,
        :messageId => message.messageId, 
        :stepValidateResponse => step_validate_response)
    end
  end
end