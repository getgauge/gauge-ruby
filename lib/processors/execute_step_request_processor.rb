require_relative "execution_handler"

module Gauge
  module Processors
    include ExecutionHandler

    def process_execute_step_request(message)
      step_text = message.executeStepRequest.parsedStepText
      parameters = message.executeStepRequest.parameters
      args = create_param_values parameters
      start_time= Time.now
      begin
        Executor.execute_step step_text, args
      rescue Exception => e
        return handle_failure message, e, time_elapsed_since(start_time)
      end
      handle_pass message, time_elapsed_since(start_time)
    end
  end
end