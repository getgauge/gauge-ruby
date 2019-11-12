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
