require_relative 'messages.pb'
require_relative 'executor'
require_relative 'table'
Dir[File.join(File.dirname(__FILE__), 'processors/*.rb')].each {|file| require file }

module Gauge

  class MessageProcessor
    extend Processors

    @processors = Hash.new
    @processors[Messages::Message::MessageType::StepValidateRequest] = method(:process_step_validation_request)
    @processors[Messages::Message::MessageType::ExecutionStarting] = method(:process_execution_start_request)
    @processors[Messages::Message::MessageType::ExecutionEnding] = method(:process_execution_end_request)
    @processors[Messages::Message::MessageType::SpecExecutionStarting] = method(:process_spec_execution_start_request)
    @processors[Messages::Message::MessageType::SpecExecutionEnding] = method(:process_spec_execution_end_request)
    @processors[Messages::Message::MessageType::ScenarioExecutionStarting] = method(:process_scenario_execution_start_request)
    @processors[Messages::Message::MessageType::ScenarioExecutionEnding] = method(:process_scenario_execution_end_request)
    @processors[Messages::Message::MessageType::StepExecutionStarting] = method(:process_step_execution_start_request)
    @processors[Messages::Message::MessageType::StepExecutionEnding] = method(:process_step_execution_end_request)
    @processors[Messages::Message::MessageType::ExecuteStep] = method(:process_execute_step_request)
    @processors[Messages::Message::MessageType::StepNamesRequest] = method(:process_step_names_request)
    @processors[Messages::Message::MessageType::KillProcessRequest] = method(:process_kill_processor_request)
    @processors[Messages::Message::MessageType::SuiteDataStoreInit] = method(:process_datastore_init)
    @processors[Messages::Message::MessageType::SpecDataStoreInit] = method(:process_datastore_init)
    @processors[Messages::Message::MessageType::ScenarioDataStoreInit] = method(:process_datastore_init)
    @processors[Messages::Message::MessageType::StepNameRequest] = method(:process_step_name_request)
    @processors[Messages::Message::MessageType::RefactorRequest] = method(:refactor_step)

    def self.is_valid_message(message)
      return @processors.has_key? message.messageType
    end

    def self.process_message(message)
      @processors[message.messageType].call message
    end
  end
end