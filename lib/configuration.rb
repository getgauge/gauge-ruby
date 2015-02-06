# Copyright 2014 ThoughtWorks, Inc.

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

module Gauge
  class << self
    def configure(&block)
      Configuration.instance.instance_eval &block
    end
  end

  class Configuration
    def initialize
      @includes=[]
    end

    def self.instance
      @configuration ||= Configuration.new
    end

    def include(*includes)
      @includes.push *includes
    end

    def includes
      @includes
    end

    def self.include_configured_modules
      # include all modules that have been configured
      # TODO: move this feature to something more specific, ex look at supporting Sandboxed execution.
      main=TOPLEVEL_BINDING.eval('self')
      self.instance.includes.each &main.method(:include)
    end
  end
end