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
        return handle_failure message, e, time_elapsed_since(start_time), MethodCache.is_recoverable?(step_text)
      end
      handle_pass message, time_elapsed_since(start_time)
    end
  end
end