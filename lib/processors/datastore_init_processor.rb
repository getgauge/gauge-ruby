require_relative '../datastore'

module Processors
  def process_datastore_init(message)
    case message.messageType
      when Gauge::Messages::Message::MessageType::SuiteDataStoreInit
        DataStoreFactory.suite_datastore.clear
      when Gauge::Messages::Message::MessageType::SpecDataStoreInit
        DataStoreFactory.spec_datastore.clear
      when Gauge::Messages::Message::MessageType::ScenarioDataStoreInit
        DataStoreFactory.scenario_datastore.clear
    end
    execution_status_response = Gauge::Messages::ExecutionStatusResponse.new(:executionResult => Gauge::Messages::ProtoExecutionResult.new(:failed => false, :executionTime => 0))
    Gauge::Messages::Message.new(:messageType => Gauge::Messages::Message::MessageType::ExecutionStatusResponse, :messageId => message.messageId, :executionStatusResponse => execution_status_response)
  end
end