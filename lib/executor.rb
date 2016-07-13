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

require_relative 'gauge'

module Gauge
  # @api private
  module Executor
    def self.load_steps(steps_implementation_dir)
      Dir["#{steps_implementation_dir}/**/*.rb"].each { |x|
        begin
          require x
        rescue Exception => e
          puts "[ERROR] Cannot import #{x}. Reason: #{e.message}"
        end
      }
    end

    def self.execute_step(step, args)
      block = MethodCache.get_step step
      if args.size == 1
        block.call(args[0])
      else
        block.call(args)
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