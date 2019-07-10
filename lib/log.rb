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
    module GaugeLog
        def self.debug(message)
            self.print('debug', message)
        end

        def self.info(message)
            self.print('info', message)
        end    
        
        def self.error(message)
            puts self.private_instance_methods
            self.print('error', message, true)
        end
        
        def self.warning(message)
            self.print('warning', message)
        end
        
        def self.fatal(message)
            self.print('fatal', message, true)
            Kernel.exit!(1)
        end

        private
        def self.print(level, message, is_error=false)
            stream = is_error ? STDERR : STDOUT
            data = JSON.dump({"logLevel" => level, "message" => message})
            stream.write "#{data}\n"
        end
    end
end
