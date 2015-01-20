module Processors
  def process_step_name_request(message)
    parsed_step_text = message.stepNameRequest.stepValue
    is_valid = valid_step?(parsed_step_text)
    step_text = is_valid ? $steps_text_map[parsed_step_text] : ""
    has_alias = $steps_with_aliases.include?(step_text)
    get_step_name_response = Gauge::Messages::StepNameResponse.new(isStepPresent: is_valid, stepName: [step_text], hasAlias: has_alias)
    Gauge::Messages::Message.new(:messageType => Gauge::Messages::Message::MessageType::StepNameResponse, :messageId => message.messageId, :stepNameResponse => get_step_name_response)
  end
end