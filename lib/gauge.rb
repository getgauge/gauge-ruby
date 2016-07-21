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

require_relative 'connector'
require_relative 'method_cache'
require_relative 'configuration'

# @api public
module Kernel
  class << self
    private
    # @!macro [attach] self.hook
    #   @method $1(&block)
    #   @api public
    #   @param block [block] this block is called while executing the $1 hook
    #   @example
    #      $1 do
    #         puts "I am the $1 hook"
    #      end
    def hook(hook)
      define_method hook do |options={}, &block|
        Gauge::MethodCache.send("add_#{hook}_hook".to_sym, options, &block)
      end
    end

    # @!macro [attach] self.tagged_hook
    #   @method $1(options, &block)
    #   @api public
    #   @param block [block] this block is called while executing the $1 hook
    #   @param {{tags: ['list', 'of', 'tags'], operator: 'OR' | 'AND'}} options specify tags and operator for which this $1 execution hook should run.
    #   @example
    #      $1({tags: ['tag2', 'tag1'], operator: 'OR'}) do
    #         puts "I am the $1 hook"
    #      end
    def tagged_hook(hook)
      hook(hook)
    end

  end

  # Specify implementation for a given step
  #
  #
  # @example
  #   step 'this is a simple step' do
  #     puts 'hello there!'
  #   end
  # @example
  #   # step with parameters
  #   # * say "hello" to "gauge"
  #   step 'say <what> to <who>' do |what, who|
  #     puts "say #{what} to #{who}"
  #   end
  # @example
  #   # step with aliases, two step texts can map to the same definition
  #   # provided they have the same parameter signature
  #   # * say "hello" to "gauge"
  #   # * When you meet "gauge", say "hello"
  #
  #   step 'say <what> to <who>', 'When you meet <who>, say <what>' do |what, who|
  #     puts "say #{what} to #{who}"
  #   end
  # @example
  #   # step with table
  #   # * Step that takes a table
  #   #        |Product|       Description           |
  #   #        |-------|-----------------------------|
  #   #        |Gauge  |BDD style testing with ease  |
  #   #        |Mingle |Agile project management     |
  #   #        |Snap   |Hosted continuous integration|
  #   #        |Gocd   |Continuous delivery platform |
  #
  #   step 'Step that takes a table <table>' do |table|
  #     # note the extra <table> that is added to the description
  #       puts x.columns.join("|")
  #       x.rows.each { |r| puts r.join("|") }
  #   end
  # @example
  #   # for a given step say
  #   # setting :continue_on_failure=>true in implementation will not break on failure of this step
  #   # and will continue to execute the next step in the scenario
  #   # * say "hello" to "gauge"
  #   step 'say <what> to <who>', :continue_on_failure => false do |what, who|
  #     puts "say #{what} to #{who}"
  #     raise "Some Failure"
  #   end
  #
  # @param step_texts [string, ...] the step text(s)
  # @param opts [Hash] pass :continue_on_failure => true to tell Gauge not to break on failure for this step
  # @param block [block] the implementation block for given step.
  def step(*args, &block)
    opts = args.select {|x| x.is_a? Hash}
    step_texts = args-opts
    opts = {:continue_on_failure => false}.merge opts.reduce({}, :merge)
    step_texts.each do |text|
      parameterized_step_text = Gauge::Connector.step_value(text)
      Gauge::MethodCache.add_step(parameterized_step_text, &block)
      Gauge::MethodCache.add_step_text(parameterized_step_text, text)
      Gauge::MethodCache.set_recoverable(parameterized_step_text) if opts[:continue_on_failure]
    end
    Gauge::MethodCache.add_step_alias(*step_texts)
  end

  # Invoked before execution of every step.
  tagged_hook "before_step"
  # Invoked after execution of every step.
  tagged_hook "after_step"
  # Invoked before execution of every specification.
  tagged_hook "before_spec"
  # Invoked after execution of every specification.
  tagged_hook "after_spec"
  # Invoked before execution of every scenario.
  tagged_hook "before_scenario"
  # Invoked after execution of every scenario.
  tagged_hook "after_scenario"
  # Invoked before execution of the entire suite.
  hook "before_suite"
  # Invoked after execution of the entire suite.
  hook "after_suite"
end
