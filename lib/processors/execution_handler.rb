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

require 'os'

module Gauge
  module Processors
    module ExecutionHandler
      def handle_hooks_execution(hooks, message, currentExecutionInfo)
        start_time= Time.now
        execution_error = Executor.execute_hooks(hooks, currentExecutionInfo)
        if execution_error == nil
          return handle_pass message, time_elapsed_since(start_time)
        else
          return handle_failure message, execution_error, time_elapsed_since(start_time)
        end
      end

      def handle_pass(message, execution_time)
        execution_status_response = Messages::ExecutionStatusResponse.new(:executionResult => Messages::ProtoExecutionResult.new(:failed => false, :executionTime => execution_time))
        Messages::Message.new(:messageType => Messages::Message::MessageType::ExecutionStatusResponse, :messageId => message.messageId, :executionStatusResponse => execution_status_response)
      end

      def handle_failure(message, exception, execution_time)
        execution_status_response = 
          Messages::ExecutionStatusResponse.new(
            :executionResult => Messages::ProtoExecutionResult.new(:failed => true,
             :recoverableError => false,
             :errorMessage => exception.message,
             :stackTrace => exception.backtrace.join("\n")+"\n",
             :executionTime => execution_time,
             :screenShot => screenshot_bytes))
        Messages::Message.new(:messageType => Messages::Message::MessageType::ExecutionStatusResponse,
          :messageId => message.messageId, :executionStatusResponse => execution_status_response)
      end

      def screenshot_bytes
        return nil if (ENV['screenshot_enabled'] || "").downcase == "false"
        # todo: make it platform independent
        if (OS.mac?)
          file = File.open("#{Dir.tmpdir}/screenshot.png", "w+")
          `screencapture #{file.path}`
          file_content = File.binread(file.path)
          File.delete file
          return file_content
        end
        return nil
      end

      def time_elapsed_since(start_time)
        ((Time.now-start_time) * 1000).round
      end

      def create_param_values parameters
        params = []
        parameters.each do |param|
          if ((param.parameterType == Messages::Parameter::ParameterType::Table) ||(param.parameterType == Messages::Parameter::ParameterType::Special_Table))
            gtable = Gauge::Table.new(param.table)
            params.push gtable
          else
            params.push param.value
          end
        end
        return params
      end  
    end
  end
end