require_relative 'connector'

def step(*stepTexts, &block)
  stepTexts.each do |text|
    parameterizedStepText = Gauge::Connector.step_value(text)
    $steps_map[parameterizedStepText] = block;
    $steps_text_map[parameterizedStepText] = text
    $steps_with_aliases.push text if stepTexts.length > 1
  end
end

  #TODO - move these to a class and encapsulate it
  $steps_map = Hash.new
  $steps_text_map = Hash.new
  $steps_with_aliases = []
  $before_suite_hooks = []
  $after_suite_hooks = []
  $before_spec_hooks = []
  $after_spec_hooks = []
  $before_scenario_hooks = []
  $after_scenario_hooks = []
  $before_step_hooks = []
  $after_step_hooks = []

    def before_step(&block)
      $before_step_hooks.push block;
    end

    def after_step(&block)
      $after_step_hooks.push block;
    end

    def before_spec(&block)
      $before_spec_hooks.push block;
    end

    def after_spec(&block)
      $after_spec_hooks.push block;
    end

    def before_scenario(&block)
      $before_scenario_hooks.push block;
    end

    def after_scenario(&block)
      $after_scenario_hooks.push block;
    end

    def before_suite(&block)
      $before_suite_hooks.push block;
    end

    def after_suite(&block)
      $after_suite_hooks.push block;
    end