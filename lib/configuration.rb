# Copyright 2015 ThoughtWorks, Inc.
#
# This file is part of Gauge-Ruby.
#
# Gauge-Ruby is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# Gauge-Ruby is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with Gauge-Ruby.  If not, see <http://www.gnu.org/licenses/>.

# Gauge runtime for Ruby language. Read more about Gauge: http://getgauge.io

# @api public
module Gauge
  class << self
    # @api public
    # Custom configuration for Gauge
    # - Lets you configure modules that need to be included at runtime.
    # - Lets you define a custom screengrabber, which will be invoked to capture screenshot on failure.
    # 
    # @example
    #   # Given there are two modules defined
    #   module Foo 
    #   end
    #
    #   module Bar
    #   end
    #
    #   # Gauge can be configured to include these modules at runtime.
    #
    #   Gauge.configure do |config|
    #     config.include Foo, Bar
    #   end
    # @example
    #   # Default behaviour is to capture the active desktop at the point of failure.
    #   # The implementation should return a byte array of the image.
    #   Gauge.configure do |config|
    #     config.screengrabber =  -> { return File.binread("/path/to/screenshot")}
    #   end
    def configure(&block)
      Configuration.instance.instance_eval &block
    end
  end

  # @api private
  class Configuration
    def initialize
      @includes=[]
      @screenshot_writer = true
      @custom_screengrabber = false
      @screengrabber = -> {
        file_name = Util.unique_screenshot_file
        `gauge_screenshot #{file_name}`
        return File.basename(file_name)
      }
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

    def screengrabber
      @screengrabber
    end

    def screengrabber=(block)
      GaugeLog.warning("[DEPRECATED] Use custom_screenshot_writer instead.")
      @screenshot_writer = false
      set_screengrabber(block)
    end

    def custom_screenshot_writer=(block)
      @screenshot_writer = true
      set_screengrabber(block)
    end

    def screenshot_writer?
      @screenshot_writer
    end

    def custom_screengrabber?
      @custom_screengrabber
    end

    def screenshot_dir
      ENV['gauge_screenshots_dir']
    end

    def self.include_configured_modules
      # include all modules that have been configured
      # TODO: move this feature to something more specific, ex look at supporting Sandboxed execution.
      main=TOPLEVEL_BINDING.eval('self')
      self.instance.includes.each &main.method(:include)
    end

    private
    def set_screengrabber(block)
      @custom_screengrabber = true
      @screengrabber=block
    end
  end
end