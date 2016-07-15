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
    def self.valid_variable_name?(var_name)
      Object.new.instance_variable_set ('@'+var_name).to_sym, nil
      true
    rescue NameError
      !!(var_name =~ /^[0-9]+$/)
    end

    def self.remove_special_chars(param)
      new_param = ''
      param.each_char { |c|
        if valid_variable_name? c
           new_param += c
        end
      }
      return new_param
      end
  end
end