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

module Gauge
  module Processors
    include ExecutionHandler

    def process_execution_start_request(message)
      handle_hooks_execution(MethodCache.get_before_suite_hooks, message, message.executionStartingRequest.currentExecutionInfo,false)
    end

    def process_execution_end_request(message)
      handle_hooks_execution(MethodCache.get_after_suite_hooks, message, message.executionEndingRequest.currentExecutionInfo, false)
    end

    def process_spec_execution_start_request(message)
      handle_hooks_execution(MethodCache.get_before_spec_hooks, message, message.specExecutionStartingRequest.currentExecutionInfo)
    end

    def process_spec_execution_end_request(message)
      handle_hooks_execution(MethodCache.get_after_spec_hooks, message, message.specExecutionEndingRequest.currentExecutionInfo)
    end

    def process_scenario_execution_start_request(message)
      handle_hooks_execution(MethodCache.get_before_scenario_hooks, message, message.scenarioExecutionStartingRequest.currentExecutionInfo)
    end

    def process_scenario_execution_end_request(message)
      handle_hooks_execution(MethodCache.get_after_scenario_hooks, message, message.scenarioExecutionEndingRequest.currentExecutionInfo)
    end

    def process_step_execution_start_request(message)
      Gauge::GaugeMessages.instance.clear
      handle_hooks_execution(MethodCache.get_before_step_hooks, message, message.stepExecutionStartingRequest.currentExecutionInfo)
    end

    def process_step_execution_end_request(message)
      response = handle_hooks_execution(MethodCache.get_after_step_hooks, message, message.stepExecutionEndingRequest.currentExecutionInfo)
      response.executionStatusResponse.executionResult.message = Gauge::GaugeMessages.instance.get
      return response
    end
  end
end
