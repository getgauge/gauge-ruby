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