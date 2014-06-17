require_relative 'connector'

$steps_map = Hash.new
$before_suite_hooks = []
$after_suite_hooks = []
$before_spec_hooks = []
$after_spec_hooks = []
$before_scenario_hooks = []
$after_scenario_hooks = []
$before_step_hooks = []
$after_step_hooks = []

def step(text, &block)
  $steps_map[Connector.step_value(text)] = block;
end

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


def load_steps(steps_implementation_dir)
  Dir["#{steps_implementation_dir}/**/*.rb"].each { |x| require x }
end

def is_valid_step(step)
  $steps_map.has_key? step
end

def execute_step(step, args)
  block = $steps_map[step]
  if args.size == 1
    block.call(args[0])
  else
    block.call(args)
  end
end

def execute_hooks(hooks, currentExecutionInfo)
  hooks.each do |hook|
    hook.call(currentExecutionInfo)
  end
  return nil
end
