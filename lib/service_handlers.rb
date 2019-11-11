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

require_relative 'runner_services_pb'
Dir[File.join(File.dirname(__FILE__), 'processors/*.rb')].each {|file| require file}

module Gauge
  class ServiceHandlers < Messages::Runner::Service
    include Processors

    def initialize(server)
      @server = server
    end

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

    def validate_step(request, _call)
      step_validate_response(request)
    end

    def refactor(request, _call)
      refactor_response(request)
    end

    def get_step_name(request, _call)
      step_name_response(request)
    end

    def get_glob_patterns(_request, _call)
      implementation_glob_pattern_response
    end

    def suite_data_store_init(*_args)
      process_datastore_init(:suite_data_store)
    end

    def spec_data_store_init(*_args)
      process_datastore_init(:spec_data_store)
    end

    def scenario_data_store_init(*_args)
      process_datastore_init(:scenario_data_store)
    end

    def execution_starting(request, _call)
      process_execution_start_request(request)
    end

    def execution_ending(request, _call)
      process_execution_end_request(request)
    end

    def spec_execution_starting(request, _call)
      process_spec_execution_start_request(request)
    end

    def spec_execution_ending(request, _call)
      process_spec_execution_end_request(request)
    end

    def scenario_execution_starting(request, _call)
      process_scenario_execution_start_request(request)
    end

    def scenario_execution_ending(request, _call)
      process_scenario_execution_end_request(request)
    end

    def step_execution_starting(request, _call)
      process_step_execution_start_request(request)
    end

    def step_execution_ending(request, _call)
      process_step_execution_end_request(request)
    end

    def execute_step(request, _call)
      process_execute_step_request(request)
    end

    def kill_process(_request, _call)
      Thread.new do
        sleep 0.1
        @server.stop
        exit(0)
      end.run
      Messages::Empty.new
    end
  end
end
