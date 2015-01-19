module Processors
  def process_step_names_request(message)
    step_names_response = Main::StepNamesResponse.new(:steps => $steps_map.keys)
    Main::Message.new(:messageType => Main::Message::MessageType::StepNamesResponse, 
      :messageId => message.messageId, :stepNamesResponse => step_names_response)
  end
end