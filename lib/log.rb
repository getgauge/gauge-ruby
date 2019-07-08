# Copyright 2018 ThoughtWorks, Inc.

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

require 'json'

module Gauge
    def debug(message)
        print('debug', message)
    end

    def info(message)
        print('info', message)
    end    
    
    def error(message)
        print('error', message, True)
    end
    
    def warning(message)
        print('warning', message)
    end
    
    def fatal(message)
        print('fatal', message, True)
    end

    private def print(level, message, is_error=false)
        stream = is_error ? STDERR : STDOUT
        data = {"logLevel" => level, "message" => message}.to_json
        stream.write "%sfrom the runner\n" [data]
    end

    # module GaugeLog
        
    # end
end
