require_relative '../code_parser'

module Processors
  def refactor_step(message)
    oldStepValue = message.refactorRequest.oldStepValue.stepValue
    newStep = message.refactorRequest.newStepValue
    stepBlock = $steps_map[oldStepValue]
    refactor_response = Gauge::Messages::RefactorResponse.new(success: true)
    begin
      Gauge::CodeParser.refactor stepBlock, message.refactorRequest.paramPositions, newStep.parameters, newStep.stepValue
    rescue Exception => e
      refactor_response.success=false
      refactor_response.error=e.message
    end
    Gauge::Messages::Message.new(:messageType => Gauge::Messages::Message::MessageType::RefactorResponse, :messageId => message.messageId, refactorResponse: refactor_response)
  end
end