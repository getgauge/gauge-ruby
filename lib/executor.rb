=begin
 *  Copyright (c) ThoughtWorks, Inc.
 *  Licensed under the Apache License, Version 2.0
 *  See LICENSE.txt in the project root for license information.
=end
require_relative 'gauge'

module Gauge
  # @api private
  module Executor
    def self.load_steps(dir)
      Dir["#{dir}/**/*.rb"].each do |x|
        begin
          GaugeLog.debug "Loading step implementations from #{x} dirs"
          ENV['GAUGE_STEP_FILE'] = x
          require x
        rescue Exception => e
          GaugeLog.error "Cannot import #{x}. Reason: #{e.message}"
        end
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
