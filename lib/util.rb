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

module Gauge
  class Util
    def self.get_param_name(params, index)
      name = "arg_#{index}"
      return name unless params.include? name
      get_param_name(params, index + 1)
    end

    def self.get_step_implementation_dir
      return File.join(ENV["GAUGE_PROJECT_ROOT"].gsub(/\\/, "/"), 'step_implementations')
    end

    def self.get_file_name(prefix = '', counter = 0)
      name = "step_implementation#{prefix}.rb"
      file_name = File.join(get_step_implementation_dir, name)
      return file_name unless File.file? file_name
      counter += 1
      get_file_name("_#{counter}", counter)
    end
  end
end
