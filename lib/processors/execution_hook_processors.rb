# Copyright 2015 ThoughtWorks, Inc.

# This file is part of Gauge-Ruby.

# Gauge-Ruby is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.

# Gauge-Ruby is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with Gauge-Ruby.  If not, see <http://www.gnu.org/licenses/>.

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
      response = handle_hooks_execution(MethodCache.get_before_suite_hooks,request.currentExecutionInfo,false)
      response.executionResult.screenshots += Gauge::GaugeScreenshot.instance.pending_screenshot
      response.executionResult.message += Gauge::GaugeMessages.instance.pending_messages
      response
    end

    def process_execution_end_request(request)
      response = handle_hooks_execution(MethodCache.get_after_suite_hooks, request.currentExecutionInfo, false)
      response.executionResult.screenshots += Gauge::GaugeScreenshot.instance.pending_screenshot
      response.executionResult.message += Gauge::GaugeMessages.instance.pending_messages
      response
    end

    def process_spec_execution_start_request(request)
      response = handle_hooks_execution(MethodCache.get_before_spec_hooks,request.currentExecutionInfo)
      response.executionResult.screenshots += Gauge::GaugeScreenshot.instance.pending_screenshot
      response.executionResult.message += Gauge::GaugeMessages.instance.pending_messages
      response
    end

    def process_spec_execution_end_request(request)
      response = handle_hooks_execution(MethodCache.get_after_spec_hooks,request.currentExecutionInfo)
      response.executionResult.screenshots += Gauge::GaugeScreenshot.instance.pending_screenshot
      response.executionResult.message += Gauge::GaugeMessages.instance.pending_messages
      response
    end

    def process_scenario_execution_start_request(request)
      response = handle_hooks_execution(MethodCache.get_before_scenario_hooks,request.currentExecutionInfo)
      response.executionResult.screenshots += Gauge::GaugeScreenshot.instance.pending_screenshot
      response.executionResult.message += Gauge::GaugeMessages.instance.pending_messages
      response
    end


    def process_scenario_execution_end_request(request)
      response = handle_hooks_execution(MethodCache.get_after_scenario_hooks,request.currentExecutionInfo)
      response.executionResult.screenshots += Gauge::GaugeScreenshot.instance.pending_screenshot
      response.executionResult.message += Gauge::GaugeMessages.instance.pending_messages
      response
    end

    def process_step_execution_start_request(request)
      response = handle_hooks_execution(MethodCache.get_before_step_hooks,request.currentExecutionInfo)
      response.executionResult.screenshots += Gauge::GaugeScreenshot.instance.pending_screenshot
      response.executionResult.message += Gauge::GaugeMessages.instance.pending_messages
      response
    end

    def process_step_execution_end_request(request)
      response = handle_hooks_execution(MethodCache.get_after_step_hooks,request.currentExecutionInfo)
      response.executionResult.screenshots += Gauge::GaugeScreenshot.instance.pending_screenshot
      response.executionResult.message += Gauge::GaugeMessages.instance.pending_messages
      response
    end
  end
end
