require_relative 'messages.pb'
require_relative 'executor'
require_relative 'table'
require 'tempfile'


def process_execute_step_request(message)
  step_text = message.executeStepRequest.parsedStepText
  arguments = message.executeStepRequest.args
  args = create_arg_values arguments
  begin
    execute_step step_text, args
  rescue Exception => e
    puts "Got excaption - #{e}"
    return handle_failure message, e
  end
  handle_pass message
end

def create_arg_values arguments
  args = []
  arguments.each do |argument|
    if (argument.type == "table")
      gtable = GaugeTable.new(argument.table)
      args.push gtable
    else
      args.push argument.value
    end
  end
  return args
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

  def self.is_valid_message(message)
    return @processors.has_key? message.messageType
  end

  def self.process_message(message)
    @processors[message.messageType].call message
  end

end

def handle_hooks_execution(hooks, message, currentExecutionInfo)
  execution_error = execute_hooks(hooks, currentExecutionInfo)
  if execution_error == nil
    return handle_pass message
  else
    return handle_failure message, execution_error
  end
end

def handle_pass(message)
  execution_status_response = Main::ExecutionStatusResponse.new(:executionResult => Main::ProtoExecutionResult.new(:failed => false))
  Main::Message.new(:messageType => Main::Message::MessageType::ExecutionStatusResponse, :messageId => message.messageId, :executionStatusResponse => execution_status_response)
end

def handle_failure(message, exception)
  execution_status_response = Main::ExecutionStatusResponse.new(:executionResult => Main::ProtoExecutionResult.new(:failed => true,
                                                                                                                   :recoverableError => false,
                                                                                                                   :errorMessage => exception.message,
                                                                                                                   :stackTrace => exception.backtrace.join("\n")+"\n",
                                                                                                                   :screenShot => screenshot_bytes))
  Main::Message.new(:messageType => Main::Message::MessageType::ExecutionStatusResponse, :messageId => message.messageId, :executionStatusResponse => execution_status_response)
end

def screenshot_bytes
  # todo: make it platform independent
  file = File.open("#{Dir.tmpdir}/screenshot.png", "w+")
  `screencapture #{file.path}`
  file_content = file.read
  File.delete file
  return file_content
end

