require_relative 'gauge'

module Gauge
  module Executor
    def self.load_steps(steps_implementation_dir)
      Dir["#{steps_implementation_dir}/**/*.rb"].each { |x| require x }
    end

    def self.valid_step?(step)
      $steps_map.has_key? step
    end

    def self.execute_step(step, args)
      block = $steps_map[step]
      if args.size == 1
        block.call(args[0])
      else
        block.call(args)
      end
    end

    def self.execute_hooks(hooks, currentExecutionInfo)
      begin
        hooks.each do |hook|
          hook.call(currentExecutionInfo)
        end
        return nil
      rescue Exception => e
        return e
      end
    end
  end
end