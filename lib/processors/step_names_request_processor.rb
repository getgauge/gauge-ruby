module Processors
  def process_step_names_request(message)
    step_names_response = Gauge::Messages::StepNamesResponse.new(:steps => $steps_map.keys)
    Gauge::Messages::Message.new(:messageType => Gauge::Messages::Message::MessageType::StepNamesResponse,
      :messageId => message.messageId, :stepNamesResponse => step_names_response)
  end
end