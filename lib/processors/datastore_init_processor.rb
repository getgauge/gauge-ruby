require_relative '../datastore'

module Gauge
  module Processors
    def process_datastore_init(message)
      case message.messageType
        when Messages::Message::MessageType::SuiteDataStoreInit
          DataStoreFactory.suite_datastore.clear
        when Messages::Message::MessageType::SpecDataStoreInit
          DataStoreFactory.spec_datastore.clear
        when Messages::Message::MessageType::ScenarioDataStoreInit
          DataStoreFactory.scenario_datastore.clear
      end
      execution_status_response = Messages::ExecutionStatusResponse.new(:executionResult => Messages::ProtoExecutionResult.new(:failed => false, :executionTime => 0))
      Messages::Message.new(:messageType => Messages::Message::MessageType::ExecutionStatusResponse, :messageId => message.messageId, :executionStatusResponse => execution_status_response)
    end
  end
end