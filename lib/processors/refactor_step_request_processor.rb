require_relative '../code_parser'

module Gauge
  module Processors
    def refactor_step(message)
      oldStepValue = message.refactorRequest.oldStepValue.stepValue
      newStep = message.refactorRequest.newStepValue
      stepBlock = MethodCache.get_step oldStepValue
      refactor_response = Messages::RefactorResponse.new(success: true)
      begin
        CodeParser.refactor stepBlock, message.refactorRequest.paramPositions, newStep.parameters, newStep.parameterizedStepValue
      rescue Exception => e
        refactor_response.success=false
        refactor_response.error=e.message
      end
      Messages::Message.new(:messageType => Messages::Message::MessageType::RefactorResponse, :messageId => message.messageId, refactorResponse: refactor_response)
    end
  end
end