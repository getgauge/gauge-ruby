=begin
 *  Copyright (c) ThoughtWorks, Inc.
 *  Licensed under the Apache License, Version 2.0
 *  See LICENSE.txt in the project root for license information.
=end
require_relative "services_services_pb"
Dir[File.join(File.dirname(__FILE__), "processors/*.rb")].each { |file| require file }

module Gauge
  class ExecutionHandler < Messages::Runner::Service
    include Processors

    def initialize(server)
      @server = server
    end

    def initialize_suite_data_store(request, _call)
      process_suite_data_store_init_request(request)
    end

    def initialize_spec_data_store(request, _call)
      process_spec_data_store_init_request(request)
    end

    def initialize_scenario_data_store(request, _call)
      process_scenario_data_store_init_request(request)
    end

    def start_execution(request, _call)
      process_execution_start_request(request)
    end

    def finish_execution(request, _call)
      process_execution_end_request(request)
    end

    def start_spec_execution(request, _call)
      process_spec_execution_start_request(request)
    end

    def finish_spec_execution(request, _call)
      process_spec_execution_end_request(request)
    end

    def start_scenario_execution(request, _call)
      process_scenario_execution_start_request(request)
    end

    def finish_scenario_execution(request, _call)
      process_scenario_execution_end_request(request)
    end

    def start_step_execution(request, _call)
      process_step_execution_start_request(request)
    end

    def finish_step_execution(request, _call)
      process_step_execution_end_request(request)
    end

    def execute_step(request, _call)
      process_execute_step_request(request)
    end

    def get_step_names(request, _call)
      process_step_names_request(request)
    end

    def cache_file(request, _call)
      process_cache_file_request(request)
    end

    def get_step_positions(request, _call)
      process_step_positions_request(request)
    end

    def get_implementation_files(request, _call)
      process_implementation_file_list_request(request)
    end

    def implement_stub(request, _call)
      process_stub_implementation_code_request(request)
    end

    def refactor(request, _call)
      process_refactor_request(request)
    end

    def get_step_name(request, _call)
      process_step_name_request(request)
    end

    def get_glob_patterns(request, _call)
      process_implementation_glob_pattern_request(request)
    end

    def validate_step(request, _call)
      process_step_validation_request(request)
    end

    def kill(_request, _call)
      Thread.new do
        sleep 0.1
        @server.stop
        exit(0)
      end.run
      Messages::Empty.new
    end
  end
end
