module Gauge
  module Processors
    def process_step_name_request(message)
      parsed_step_text = message.stepNameRequest.stepValue
      is_valid = MethodCache.valid_step?(parsed_step_text)
      step_text = is_valid ? MethodCache.get_step_text(parsed_step_text) : ""
      has_alias = MethodCache.has_alias?(step_text)
      get_step_name_response = Messages::StepNameResponse.new(isStepPresent: is_valid, stepName: [step_text], hasAlias: has_alias)
      Messages::Message.new(:messageType => Messages::Message::MessageType::StepNameResponse, :messageId => message.messageId, :stepNameResponse => get_step_name_response)
    end
  end
end