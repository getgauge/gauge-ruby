require_relative 'configuration'
module Gauge
  class MethodCache
    HOOKS = ["before_step", "after_step", "before_spec", "after_spec", "before_scenario", "after_scenario", "before_suite", "after_suite"]

    HOOKS.each { |hook|
      define_singleton_method "add_#{hook}_hook" do |&block|
        self.class_variable_get("@@#{hook}_hooks").push block
      end
      define_singleton_method "get_#{hook}_hooks" do
        self.class_variable_get("@@#{hook}_hooks")
      end
    }

    def self.add_step(parameterized_step_text, &block)
      @@steps_map[parameterized_step_text] = block
    end

    def self.get_step(parameterized_step_text)
      @@steps_map[parameterized_step_text]
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
      @@steps_map.keys
    end

    private
    @@steps_map = Hash.new
    @@steps_text_map = Hash.new
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