=begin
 *  Copyright (c) ThoughtWorks, Inc.
 *  Licensed under the Apache License, Version 2.0
 *  See LICENSE.txt in the project root for license information.
=end
require_relative "execution_handler"

module Gauge
  module Processors
    include ExecutionHandler

    def process_execute_step_request(request)
      step_text = request.parsedStepText
      parameters = request.parameters
      args = create_param_values parameters
      start_time= Time.now
      begin
        Executor.execute_step step_text, args
      rescue Exception => e
        return handle_failure e, time_elapsed_since(start_time), MethodCache.recoverable?(step_text)
      end
      handle_pass time_elapsed_since(start_time)
    end
  end
end
