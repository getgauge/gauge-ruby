=begin
 *  Copyright (c) ThoughtWorks, Inc.
 *  Licensed under the Apache License, Version 2.0
 *  See LICENSE.txt in the project root for license information.
=end
module Gauge
  module Processors
    def process_step_validation_request(request)
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
