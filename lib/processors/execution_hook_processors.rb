=begin
 *  Copyright (c) ThoughtWorks, Inc.
 *  Licensed under the Apache License, Version 2.0
 *  See LICENSE.txt in the project root for license information.
=end
require_relative "execution_handler"
require_relative "../gauge_messages"
require_relative "../gauge_screenshot"
require_relative "../executor"
require_relative "../method_cache"
require_relative "../util"
module Gauge
  module Processors
    include ExecutionHandler

    def process_execution_start_request(request)
      Gauge::MethodCache.clear
      Executor.load_steps(Util.get_step_implementation_dir)
      handle_hooks_execution(MethodCache.get_before_suite_hooks,request.currentExecutionInfo,false)
    end

    def process_execution_end_request(request)
      handle_hooks_execution(MethodCache.get_after_suite_hooks, request.currentExecutionInfo, false)
    end

    def process_spec_execution_start_request(request)
      handle_hooks_execution(MethodCache.get_before_spec_hooks,request.currentExecutionInfo)
    end

    def process_spec_execution_end_request(request)
      handle_hooks_execution(MethodCache.get_after_spec_hooks,request.currentExecutionInfo)
    end

    def process_scenario_execution_start_request(request)
      handle_hooks_execution(MethodCache.get_before_scenario_hooks,request.currentExecutionInfo)
    end


    def process_scenario_execution_end_request(request)
      handle_hooks_execution(MethodCache.get_after_scenario_hooks,request.currentExecutionInfo)
    end

    def process_step_execution_start_request(request)
      handle_hooks_execution(MethodCache.get_before_step_hooks,request.currentExecutionInfo)
    end

    def process_step_execution_end_request(request)
      handle_hooks_execution(MethodCache.get_after_step_hooks,request.currentExecutionInfo)
    end
  end
end
