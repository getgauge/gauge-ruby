=begin
 *  Copyright (c) ThoughtWorks, Inc.
 *  Licensed under the Apache License, Version 2.0
 *  See LICENSE.txt in the project root for license information.
=end
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
