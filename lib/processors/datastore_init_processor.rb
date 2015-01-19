require_relative '../datastore'

module Processors
  def process_datastore_init(message)
    case message.messageType
      when Main::Message::MessageType::SuiteDataStoreInit
        DataStoreFactory.suite_datastore.clear
      when Main::Message::MessageType::SpecDataStoreInit
        DataStoreFactory.spec_datastore.clear
      when Main::Message::MessageType::ScenarioDataStoreInit
        DataStoreFactory.scenario_datastore.clear
    end
    execution_status_response = Main::ExecutionStatusResponse.new(:executionResult => Main::ProtoExecutionResult.new(:failed => false, :executionTime => 0))
    Main::Message.new(:messageType => Main::Message::MessageType::ExecutionStatusResponse, :messageId => message.messageId, :executionStatusResponse => execution_status_response)
  end
end