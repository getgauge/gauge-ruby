module Gauge
  module Processors
    def process_step_validation_request(message)
      step_validate_request = message.stepValidateRequest
      is_valid = Executor.valid_step?(step_validate_request.stepText)
      step_validate_response = Messages::StepValidateResponse.new(:isValid => is_valid,
        :errorMessage => is_valid ? "" : "Step implementation not found")
      Messages::Message.new(:messageType => Messages::Message::MessageType::StepValidateResponse,
        :messageId => message.messageId, 
        :stepValidateResponse => step_validate_response)
    end
  end
end