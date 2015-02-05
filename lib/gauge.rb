require_relative 'connector'
require_relative 'method_cache'
require_relative 'configuration'

module Kernel
  def step(*step_texts, &block)
    step_texts.each do |text|
      parameterized_step_text = Gauge::Connector.step_value(text)
      Gauge::MethodCache.add_step(parameterized_step_text, &block)
      Gauge::MethodCache.add_step_text(parameterized_step_text, text)
    end
    Gauge::MethodCache.add_step_alias(*step_texts)
  end

  Gauge::MethodCache::HOOKS.each { |hook| 
    define_method hook do |&block|
      Gauge::MethodCache.send("add_#{hook}_hook".to_sym, &block)
    end
  }
end