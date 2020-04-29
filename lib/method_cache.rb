=begin
 *  Copyright (c) ThoughtWorks, Inc.
 *  Licensed under the Apache License, Version 2.0
 *  See LICENSE.txt in the project root for license information.
=end
require_relative 'configuration'
module Gauge
  # @api private
  class MethodCache
    %w[before_step after_step before_spec after_spec before_scenario after_scenario before_suite after_suite].each { |hook|
      define_singleton_method "add_#{hook}_hook" do |options = {}, &block|
        options = {operator: "AND", tags: []}.merge options
        class_variable_get("@@#{hook}_hooks").push :block => block, :options => options
      end
      define_singleton_method "get_#{hook}_hooks" do
        class_variable_get("@@#{hook}_hooks")
      end
    }

    def self.clear_hooks(hook)
      class_variable_get("@@#{hook}_hooks").clear
    end

    def self.clear()
      @@steps_map.clear
    end

    def self.add_step(step_value, step_info)
      if @@steps_map.key? step_value
        @@steps_map[step_value][:locations].push(step_info[:location])
      else
        @@steps_map[step_value] = {
            locations: [step_info[:location]],
            block: step_info[:block],
            step_text: step_info[:step_text],
            recoverable: step_info[:recoverable]
        }
      end
    end

    def self.get_step_info(step_value)
      @@steps_map[step_value]
    end


    def self.get_step_text(step_value)
      @@steps_map[step_value][:step_text]
    end

    def self.add_step_alias(*step_texts)
      @@steps_with_aliases.push *step_texts if step_texts.length > 1
    end

    def self.has_alias?(step_text)
      @@steps_with_aliases.include? step_text
    end

    def self.valid_step?(step)
      @@steps_map.key? step
    end

    def self.all_steps
      @@steps_map.values.map { |si| si[:step_text] }
    end

    def self.recoverable?(step_value)
      @@steps_map[step_value][:recoverable]
    end

    def self.relative_filepath(file)
      project_root =  Pathname.new(ENV['GAUGE_PROJECT_ROOT'])
      filename = Pathname.new(file).relative_path_from(project_root)
      return project_root.join(filename.to_s.split(":").first)
    end

    def self.remove_steps(file)
      @@steps_map.each_pair do |step, info|
        l = info[:locations].reject { |loc| relative_filepath(loc[:file]).eql? relative_filepath(file) }
        l.empty? ? @@steps_map.delete(step) : @@steps_map[step][:locations] = l
      end
    end

    def self.is_file_cached(file)
      @@steps_map.each_pair do |step, info|
        if info[:locations].any? { |loc| relative_filepath(loc[:file]).eql? relative_filepath(file) }
          return true
        end
      end
      return false
    end

    def self.multiple_implementation?(step_value)
      @@steps_map[step_value][:locations].length > 1
    end

    def self.step_positions(file)
      step_positions = []
      @@steps_map.each_pair do |step, info|
        info[:locations].each do |location|
          if location[:file] == file
            step_positions.push({stepValue: step, span: location[:span]})
          end
        end
      end
      step_positions
    end

    private
    @@steps_map = Hash.new
    @@steps_with_aliases = []
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
