module Processors
  def process_step_validation_request(message)
    step_validate_request = message.stepValidateRequest
    is_valid = valid_step?(step_validate_request.stepText)
    step_validate_response = Main::StepValidateResponse.new(:isValid => is_valid,
      :errorMessage => is_valid ? "" : "Step implementation not found")
    Main::Message.new(:messageType => Main::Message::MessageType::StepValidateResponse, 
      :messageId => message.messageId, 
      :stepValidateResponse => step_validate_response)
  end
end