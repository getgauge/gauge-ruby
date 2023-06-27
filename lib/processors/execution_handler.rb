=begin
 *  Copyright (c) ThoughtWorks, Inc.
 *  Licensed under the Apache License, Version 2.0
 *  See LICENSE.txt in the project root for license information.
=end
require_relative '../table'

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
        execution_status_response.executionResult.screenshotFiles += Gauge::GaugeScreenshot.instance.pending_screenshot
        execution_status_response.executionResult.message += Gauge::GaugeMessages.instance.pending_messages
        execution_status_response
      end

      def get_filepath(stacktrace)
        toptrace = stacktrace.split("\n").first
        MethodCache.relative_filepath toptrace
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
        screenshot_file = take_screenshot
        if screenshot_file 
          execution_status_response.executionResult.failureScreenshotFile = screenshot_file
        end
        execution_status_response.executionResult.screenshotFiles += Gauge::GaugeScreenshot.instance.pending_screenshot
        execution_status_response.executionResult.message += Gauge::GaugeMessages.instance.pending_messages
        execution_status_response
      end

      def get_code_snippet(filename, number)
        return nil if number < 1
        line = File.readlines(filename)[number-1]
        number.to_s + " | " + line.strip + "\n\n"
      end

      def take_screenshot
        return nil if (ENV['screenshot_on_failure'] || "").downcase == "false" || (which("gauge_screenshot").nil? && !Configuration.instance.custom_screengrabber?)
        begin
          GaugeScreenshot.instance.capture_to_file
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
