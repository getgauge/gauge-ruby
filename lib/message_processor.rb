require_relative 'messages.pb'
require_relative 'executor'
require_relative 'table'
Dir[File.join(File.dirname(__FILE__), 'processors/*.rb')].each {|file| require file }

include Processors
include ExecutionHandler

class MessageProcessor
  @processors = Hash.new
  @processors[Main::Message::MessageType::StepValidateRequest] = method(:process_step_validation_request)
  @processors[Main::Message::MessageType::ExecutionStarting] = method(:process_execution_start_request)
  @processors[Main::Message::MessageType::ExecutionEnding] = method(:process_execution_end_request)
  @processors[Main::Message::MessageType::SpecExecutionStarting] = method(:process_spec_execution_start_request)
  @processors[Main::Message::MessageType::SpecExecutionEnding] = method(:process_spec_execution_end_request)
  @processors[Main::Message::MessageType::ScenarioExecutionStarting] = method(:process_scenario_execution_start_request)
  @processors[Main::Message::MessageType::ScenarioExecutionEnding] = method(:process_scenario_execution_end_request)
  @processors[Main::Message::MessageType::StepExecutionStarting] = method(:process_step_execution_start_request)
  @processors[Main::Message::MessageType::StepExecutionEnding] = method(:process_step_execution_end_request)
  @processors[Main::Message::MessageType::ExecuteStep] = method(:process_execute_step_request)
  @processors[Main::Message::MessageType::StepNamesRequest] = method(:process_step_names_request)
  @processors[Main::Message::MessageType::KillProcessRequest] = method(:process_kill_processor_request)
  @processors[Main::Message::MessageType::SuiteDataStoreInit] = method(:process_datastore_init)
  @processors[Main::Message::MessageType::SpecDataStoreInit] = method(:process_datastore_init)
  @processors[Main::Message::MessageType::ScenarioDataStoreInit] = method(:process_datastore_init)
  @processors[Main::Message::MessageType::StepNameRequest] = method(:process_step_name_request)
  @processors[Main::Message::MessageType::RefactorRequest] = method(:refactor_step)

  def self.is_valid_message(message)
    return @processors.has_key? message.messageType
  end

  def self.process_message(message)
    @processors[message.messageType].call message
  end
end