require_relative 'gauge-ruby'

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
