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

require_relative 'lsp.pb'
Dir[File.join(File.dirname(__FILE__), 'processors/*.rb')].each {|file| require file}

module Gauge
    class LSPServer < Gauge::Messages::LspService
        def get_step_names(request)
            Gauge::Processors::step_name_response(request)
        end

        def cache_file
            Gauge::Processors::cache_file(request)
        end

        def get_step_positions
            Gauge::Processors::step_positions(request)
        end

        def get_implementation_files
            Gauge::Processors::implementation_files()
        end

        def implement_stub
            Gauge::Processors::implement_stub(request)
        end
    end
end