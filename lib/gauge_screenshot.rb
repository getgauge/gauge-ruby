=begin
 *  Copyright (c) ThoughtWorks, Inc.
 *  Licensed under the Apache License, Version 2.0
 *  See LICENSE.txt in the project root for license information.
=end
require_relative './util'
module Gauge
  class << self
    def capture
      GaugeScreenshot.instance.capture
    end
  end

  class GaugeScreenshot
    def initialize
      @screenshots = []
    end

    def self.instance
      @gauge_screenshots ||= GaugeScreenshot.new
    end      

    def capture
      @screenshots.push(capture_to_file)
    end

    def capture_to_file
      unless Configuration.instance.screenshot_writer?
        content = Configuration.instance.screengrabber.call
        file_name = Util.unique_screenshot_file
        File.write(file_name, content)
        return File.basename(file_name)
      end
      Configuration.instance.screengrabber.call
    end

    def pending_screenshot
      pending_screenshot = @screenshots
      clear
      pending_screenshot
    end

    def get
      @screenshots
    end

    def clear
      @screenshots = []
    end

  end
end
