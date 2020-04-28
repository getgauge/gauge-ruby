=begin
 *  Copyright (c) ThoughtWorks, Inc.
 *  Licensed under the Apache License, Version 2.0
 *  See LICENSE.txt in the project root for license information.
=end
require_relative "../datastore"

module Gauge
  module Processors
    def process_suite_data_store_init_request(_request)
      DataStoreFactory.suite_datastore.clear
      datastore_response
    end

    def process_spec_data_store_init_request(_request)
      DataStoreFactory.spec_datastore.clear
      datastore_response
    end

    def process_scenario_data_store_init_request(_request)
      DataStoreFactory.scenario_datastore.clear
      datastore_response
    end

    def datastore_response
      Messages::ExecutionStatusResponse.new(:executionResult => Messages::ProtoExecutionResult.new(:failed => false, :executionTime => 0))
    end
  end
end
