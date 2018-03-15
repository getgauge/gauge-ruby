# Copyright 2018 ThoughtWorks, Inc.

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
require 'ruby-debug-ide'
require_relative 'gauge'

ATTACH_DEBUGGER_EVENT = "Runner Ready for Debugging"

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
          ENV['GAUGE_STEP_FILE'] = x
          require x
        rescue Exception => e
          Gauge::Log.error "[ERROR] Cannot import #{x}. Reason: #{e.message}"
        end
      end
    end

    def self.start_debugger
      if ENV['DEBUGGING']
        options = DebugOptions.new
        options.host = '127.0.0.1'
        options.port = ENV["DEBUG_PORT"].to_i
        options.notify_dispatcher = false
        Gauge::Log.info ATTACH_DEBUGGER_EVENT
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
      begin
        hooks.each do |hook|
          if !should_filter || hook[:options][:tags].length == 0
            next hook[:block].call(currentExecutionInfo)
          end
          tags = currentExecutionInfo.currentSpec.tags + currentExecutionInfo.currentScenario.tags
          intersection = (tags & hook[:options][:tags])
          if (hook[:options][:operator] == 'OR' && intersection.length > 0) ||
              (hook[:options][:operator] == 'AND' && intersection.length == hook[:options][:tags].length)
            hook[:block].call(currentExecutionInfo)
          end
        end
        return nil
      rescue Exception => e
        return e
      end
    end
  end
end