module Processors
  def process_step_validation_request(message)
    step_validate_request = message.stepValidateRequest
    is_valid = valid_step?(step_validate_request.stepText)
    step_validate_response = Gauge::Messages::StepValidateResponse.new(:isValid => is_valid,
      :errorMessage => is_valid ? "" : "Step implementation not found")
    Gauge::Messages::Message.new(:messageType => Gauge::Messages::Message::MessageType::StepValidateResponse,
      :messageId => message.messageId, 
      :stepValidateResponse => step_validate_response)
  end
end