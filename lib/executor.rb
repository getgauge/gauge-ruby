=begin
 *  Copyright (c) ThoughtWorks, Inc.
 *  Licensed under the Apache License, Version 2.0
 *  See LICENSE.txt in the project root for license information.
=end
require 'ruby-debug-ide'
require_relative 'gauge'

ATTACH_DEBUGGER_EVENT = 'Runner Ready for Debugging'

module Gauge
  class DebugOptions
    attr_accessor :host, :port, :notify_dispatcher
  end

  # @api private
  module Executor
    def self.load_steps(dir)
      start_debugger
      Dir["#{dir}/**/*.rb"].each do |x|
        begin
          GaugeLog.info "Loading step implemetations from #{x} dirs"
          ENV['GAUGE_STEP_FILE'] = x
          require x
        rescue Exception => e
          GaugeLog.error "Cannot import #{x}. Reason: #{e.message}"
        end
      end
    end

    def self.start_debugger
      if ENV['DEBUGGING']
        options = DebugOptions.new
        options.host = '127.0.0.1'
        options.port = ENV['DEBUG_PORT'].to_i
        options.notify_dispatcher = false
        GaugeLog.info ATTACH_DEBUGGER_EVENT
        Debugger.prepare_debugger(options)
      end
    end

    def self.execute_step(step, args)
      si = MethodCache.get_step_info step
      if args.size == 1
        si[:block].call(args[0])
      else
        si[:block].call(args)
      end
    end

    def self.execute_hooks(hooks, currentExecutionInfo, should_filter)
      hooks.each do |hook|
        if !should_filter || hook[:options][:tags].empty?
          next hook[:block].call(currentExecutionInfo)
        end
        tags = currentExecutionInfo.currentSpec.tags + get_scenario_tags(currentExecutionInfo)
        intersection = (tags & hook[:options][:tags])
        if (hook[:options][:operator] == 'OR' && !intersection.empty?) ||
           (hook[:options][:operator] == 'AND' && intersection.length == hook[:options][:tags].length)
          hook[:block].call(currentExecutionInfo)
        end
      end
      nil
    rescue Exception => e
      e
    end

    def self.get_scenario_tags(info)
      !info.currentScenario.nil? ? info.currentScenario.tags : []
    end
  end
end
