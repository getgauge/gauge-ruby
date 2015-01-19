module Processors
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
end