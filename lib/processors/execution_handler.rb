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
    # @api private
    module ExecutionHandler
      def handle_hooks_execution(hooks, currentExecutionInfo, should_filter=true)
        start_time= Time.now
        execution_error = Executor.execute_hooks(hooks, currentExecutionInfo, should_filter)
        if execution_error == nil
          return handle_pass time_elapsed_since(start_time)
        else
          return handle_failure execution_error, time_elapsed_since(start_time), false
        end
      end

      def handle_pass(execution_time)
        execution_status_response = Messages::ExecutionStatusResponse.new(:executionResult => Messages::ProtoExecutionResult.new(:failed => false, :executionTime => execution_time))
        execution_status_response.executionResult.screenshots += Gauge::GaugeScreenshot.instance.pending_screenshot
        execution_status_response.executionResult.message += Gauge::GaugeMessages.instance.pending_messages
        execution_status_response
      end

      def get_filepath(stacktrace)
        toptrace = stacktrace.split("\n").first
        return MethodCache.relative_filepath toptrace
      end
    
      def handle_failure(exception, execution_time, recoverable)
        project_dir = File.basename(Dir.getwd)
        stacktrace =  exception.backtrace.select {|x| x.match(project_dir) && !x.match(File.join(project_dir, "vendor"))}.join("\n")+"\n"
        filepath = get_filepath(stacktrace)
        line_number =  stacktrace.split("\n").first.split("/").last.split(":")[1]
        code_snippet = "\n" + '> ' + get_code_snippet(filepath, line_number.to_i)
        execution_status_response =
          Messages::ExecutionStatusResponse.new(
            :executionResult => Messages::ProtoExecutionResult.new(:failed => true,
             :recoverableError => recoverable,
             :errorMessage => exception.message,
             :stackTrace => code_snippet + stacktrace,
             :executionTime => execution_time))
        screenshot = screenshot_bytes
        if screenshot 
          execution_status_response.executionResult.screenShot = screenshot
          execution_status_response.executionResult.failureScreenshot = screenshot
        end
        execution_status_response.executionResult.screenshots += Gauge::GaugeScreenshot.instance.pending_screenshot
        execution_status_response.executionResult.message += Gauge::GaugeMessages.instance.pending_messages
        execution_status_response
      end

      def get_code_snippet(filename, number)
        return nil if number < 1
        line = File.readlines(filename)[number-1]
        number.to_s + " | " + line.strip + "\n\n"
      end

      def screenshot_bytes
        return nil if (ENV['screenshot_on_failure'] || "").downcase == "false" || (which("gauge_screenshot").nil? && !Configuration.instance.custom_screengrabber)
        begin
          Configuration.instance.screengrabber.call
        rescue Exception => e
          GaugeLog.error e
          return nil
        end
      end

      def time_elapsed_since(start_time)
        ((Time.now-start_time) * 1000).round
      end

      def create_param_values parameters
        params = []
        parameters.each do |param|
          if ((param.parameterType == :Table) ||(param.parameterType == :Special_Table))
            gtable = Gauge::Table.new(param.table)
            params.push gtable
          else
            params.push param.value
          end
        end
        return params
      end

      private
      def which(cmd)
        exts = ENV['PATHEXT'] ? ENV['PATHEXT'].split(';') : ['']
        ENV['PATH'].split(File::PATH_SEPARATOR).each do |path|
          exts.each { |ext|
            exe = File.join(path, "#{cmd}#{ext}")
            return exe if File.executable?(exe) && !File.directory?(exe)
          }
        end
        return nil
      end
    end
  end
end
