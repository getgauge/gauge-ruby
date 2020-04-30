=begin
 *  Copyright (c) ThoughtWorks, Inc.
 *  Licensed under the Apache License, Version 2.0
 *  See LICENSE.txt in the project root for license information.
=end
module Gauge
  class Util
    class << self
      def get_param_name(params, index)
        name = "arg_#{index}"
        return name unless params.include? name
        get_param_name(params, index + 1)
      end

      def get_step_implementation_dir
        return File.join(ENV["GAUGE_PROJECT_ROOT"].gsub(/\\/, "/"), "step_implementations")
      end

      def get_file_name(prefix = "", counter = 0)
        name = "step_implementation#{prefix}.rb"
        file_name = File.join(get_step_implementation_dir, name)
        return file_name unless File.file? file_name
        counter += 1
        get_file_name("_#{counter}", counter)
      end

      def step_value(text)
        text.gsub(/(<.*?>)/, "{}")
      end
      def unique_screenshot_file
        base_name = "screenshot-#{Process.pid}-#{(Time.now.to_f*10000).to_i}.png"
        File.join(ENV['gauge_screenshots_dir'],base_name)
      end
    end
  end
end
