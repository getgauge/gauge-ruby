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
      request = message.stepValidateRequest
      Messages::Message.new(messageType: :StepValidateResponse,
                            messageId: message.messageId,
                            stepValidateResponse: step_validate_response(request))
    end

    def step_validate_response(request)
      response = Messages::StepValidateResponse.new(isValid: true)
      if !MethodCache.valid_step? request.stepText
        suggestion = request.stepValue.stepValue.empty? ? '' : create_suggestion(request.stepValue)
        response = Messages::StepValidateResponse.new(
          isValid: false,
          errorMessage: 'Step implementation not found',
          errorType: Messages::StepValidateResponse::ErrorType::STEP_IMPLEMENTATION_NOT_FOUND,
          suggestion: suggestion
        )
      elsif MethodCache.multiple_implementation?(request.stepText)
        response = Messages::StepValidateResponse.new(
          isValid: false,
          errorMessage: "Multiple step implementations found for => '#{request.stepText}'",
          errorType: Messages::StepValidateResponse::ErrorType::DUPLICATE_STEP_IMPLEMENTATION
        )
      end
      response
    end

    def create_suggestion(step_value)
      count = -1
      step_text = step_value.stepValue.gsub(/{}/) { "<arg#{count += 1}>" }
      params = step_value.parameters.map.with_index { |_v, i| "arg#{i}" }.join ', '
      "step '#{step_text}' do |#{params}|\n\traise 'Unimplemented Step'\nend"
    end
  end
end
