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

require_relative 'lsp_services_pb'
require_relative 'processors/step_positions_request_processor'
require_relative 'processors/cache_file_processor'
require_relative 'processors/step_names_request_processor'
require_relative 'processors/stub_implementation_processor'
require_relative 'processors/implementation_file_list_processor'

module Gauge
  class LSPServer < Gauge::Messages::LspService::Service
    include Gauge::Processors

    def get_step_names(_request, _call)
      step_names_response
    end

    def cache_file(request, _call)
      cache_file_response(request)
    end

    def get_step_positions(request, _call)
      step_positions(request)
    end

    def get_implementation_files(_request, _call)
      implementation_files
    end

    def implement_stub(request, _call)
      implement_stub_response(request)
    end
  end
end
