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

require_relative 'configuration'
module Gauge
  # @api private
  class MethodCache
    ["before_step", "after_step", "before_spec", "after_spec", "before_scenario", "after_scenario", "before_suite", "after_suite"].each { |hook|
      define_singleton_method "add_#{hook}_hook" do |options={}, &block|
        options = {operator: "AND", tags: []}.merge options
        self.class_variable_get("@@#{hook}_hooks").push :block=>  block, :options=> options
      end
      define_singleton_method "get_#{hook}_hooks" do
        self.class_variable_get("@@#{hook}_hooks")
      end
    }

    def self.clear_hooks(hook)
      self.class_variable_get("@@#{hook}_hooks").clear
    end

    def self.add_step(parameterized_step_text, &block)
      @@steps_map[parameterized_step_text] = @@steps_map[parameterized_step_text] || []
      @@steps_map[parameterized_step_text].push(block)
    end

    def self.get_step(parameterized_step_text)
      @@steps_map[parameterized_step_text][0]
    end

    def self.get_steps(parameterized_step_text)
      @@steps_map[parameterized_step_text] || []
    end

    def self.add_step_text(parameterized_step_text, step_text)
      @@steps_text_map[parameterized_step_text] = step_text
    end

    def self.get_step_text(parameterized_step_text)
      @@steps_text_map[parameterized_step_text]
    end

    def self.add_step_alias(*step_texts)
      @@steps_with_aliases.push *step_texts if step_texts.length > 1
    end

    def self.has_alias?(step_text)
      @@steps_with_aliases.include? step_text
    end

    def self.valid_step?(step)
      @@steps_map.has_key? step
    end

    def self.all_steps
      @@steps_text_map.values
    end

    def self.is_recoverable?(parameterized_step_text)
      @@recoverable_steps.include? parameterized_step_text
    end

    def self.set_recoverable(parameterized_step_text)
      @@recoverable_steps.push parameterized_step_text
    end

    private
    @@steps_map = Hash.new
    @@steps_text_map = Hash.new
    @@steps_with_aliases = []
    @@recoverable_steps = []
    @@before_suite_hooks = []
    @@after_suite_hooks = []
    @@before_spec_hooks = []
    @@after_spec_hooks = []
    @@before_scenario_hooks = []
    @@after_scenario_hooks = []
    @@before_step_hooks = []
    @@after_step_hooks = []
  end

  # hack : get the 'main' object and include the configured includes there.
  # can be removed once we have scoped execution.
  MethodCache.add_before_suite_hook { Configuration.include_configured_modules }
end
