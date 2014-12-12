require_relative 'messages.pb'
require_relative 'executor'
require_relative 'table'
require 'os'
require 'tempfile'
require_relative 'datastore'


def time_elapsed_since(start_time)
  ((Time.now-start_time) * 1000).round
end

def process_execute_step_request(message)
  step_text = message.executeStepRequest.parsedStepText
  parameters = message.executeStepRequest.parameters
  args = create_param_values parameters
  start_time= Time.now
  begin
    execute_step step_text, args
  rescue Exception => e
    return handle_failure message, e, time_elapsed_since(start_time)
  end
  handle_pass message, time_elapsed_since(start_time)
end

def create_param_values parameters
  params = []
  parameters.each do |param|
    if ((param.parameterType == Main::Parameter::ParameterType::Table) ||(param.parameterType == Main::Parameter::ParameterType::Special_Table))
      gtable = GaugeTable.new(param.table)
      params.push gtable
    else
      params.push param.value
    end
  end
  return params
end

def process_execution_start_request(message)
  handle_hooks_execution($before_suite_hooks, message, message.executionStartingRequest.currentExecutionInfo)
end

def process_execution_end_request(message)
  handle_hooks_execution($after_suite_hooks, message, message.executionEndingRequest.currentExecutionInfo)
end

def process_spec_execution_start_request(message)
  handle_hooks_execution($before_spec_hooks, message, message.specExecutionStartingRequest.currentExecutionInfo)
end

def process_spec_execution_end_request(message)
  handle_hooks_execution($after_spec_hooks, message, message.specExecutionEndingRequest.currentExecutionInfo)
end

def process_scenario_execution_start_request(message)
  handle_hooks_execution($before_scenario_hooks, message, message.scenarioExecutionStartingRequest.currentExecutionInfo)
end

def process_scenario_execution_end_request(message)
  handle_hooks_execution($after_scenario_hooks, message, message.scenarioExecutionEndingRequest.currentExecutionInfo)
end

def process_step_execution_start_request(message)
  handle_hooks_execution($before_step_hooks, message, message.stepExecutionStartingRequest.currentExecutionInfo)
end

def process_step_execution_end_request(message)
  handle_hooks_execution($after_step_hooks, message, message.stepExecutionEndingRequest.currentExecutionInfo)
end

def process_step_validation_request(message)
  step_validate_request = message.stepValidateRequest
  step_validate_response = Main::StepValidateResponse.new(:isValid => is_valid_step(step_validate_request.stepText))
  Main::Message.new(:messageType => Main::Message::MessageType::StepValidateResponse, :messageId => message.messageId, :stepValidateResponse => step_validate_response)
end

def process_step_names_request(message)
  step_names_response = Main::StepNamesResponse.new(:steps => $steps_map.keys)
  Main::Message.new(:messageType => Main::Message::MessageType::StepNamesResponse, :messageId => message.messageId, :stepNamesResponse => step_names_response)
end

def process_kill_processor_request(message)
  return message
end

def dataStoreInit(message)
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
  @processors[Main::Message::MessageType::SuiteDataStoreInit] = method(:dataStoreInit)
  @processors[Main::Message::MessageType::SpecDataStoreInit] = method(:dataStoreInit)
  @processors[Main::Message::MessageType::ScenarioDataStoreInit] = method(:dataStoreInit)

  def self.is_valid_message(message)
    return @processors.has_key? message.messageType
  end

  def self.process_message(message)
    @processors[message.messageType].call message
  end

end

def handle_hooks_execution(hooks, message, currentExecutionInfo)
  start_time= Time.now
  execution_error = execute_hooks(hooks, currentExecutionInfo)
  if execution_error == nil
    return handle_pass message, time_elapsed_since(start_time)
  else
    return handle_failure message, execution_error, time_elapsed_since(start_time)
  end
end

def handle_pass(message, execution_time)
  execution_status_response = Main::ExecutionStatusResponse.new(:executionResult => Main::ProtoExecutionResult.new(:failed => false, :executionTime => execution_time))
  Main::Message.new(:messageType => Main::Message::MessageType::ExecutionStatusResponse, :messageId => message.messageId, :executionStatusResponse => execution_status_response)
end

def handle_failure(message, exception, execution_time)
  execution_status_response = Main::ExecutionStatusResponse.new(:executionResult => Main::ProtoExecutionResult.new(:failed => true,
                                                                                                                   :recoverableError => false,
                                                                                                                   :errorMessage => exception.message,
                                                                                                                   :stackTrace => exception.backtrace.join("\n")+"\n",
                                                                                                                   :executionTime => execution_time,
                                                                                                                   :screenShot => screenshot_bytes))
  Main::Message.new(:messageType => Main::Message::MessageType::ExecutionStatusResponse, :messageId => message.messageId, :executionStatusResponse => execution_status_response)
end

def screenshot_bytes
  # todo: make it platform independent
  if (OS.mac?)
    file = File.open("#{Dir.tmpdir}/screenshot.png", "w+")
    `screencapture #{file.path}`
    file_content = File.read file.path
    File.delete file
    return file_content
  end
  return nil
end