module Gauge
  module Processors
    def process_step_names_request(message)
      step_names_response = Messages::StepNamesResponse.new(:steps => $steps_map.keys)
      Messages::Message.new(:messageType => Messages::Message::MessageType::StepNamesResponse,
        :messageId => message.messageId, :stepNamesResponse => step_names_response)
    end
  end
end