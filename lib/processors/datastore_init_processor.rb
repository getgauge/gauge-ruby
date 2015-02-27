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

require_relative '../datastore'

module Gauge
  # @api private
  module Processors
    def process_datastore_init(message)
      case message.messageType
        when Messages::Message::MessageType::SuiteDataStoreInit
          DataStoreFactory.suite_datastore.clear
        when Messages::Message::MessageType::SpecDataStoreInit
          DataStoreFactory.spec_datastore.clear
        when Messages::Message::MessageType::ScenarioDataStoreInit
          DataStoreFactory.scenario_datastore.clear
      end
      execution_status_response = Messages::ExecutionStatusResponse.new(:executionResult => Messages::ProtoExecutionResult.new(:failed => false, :executionTime => 0))
      Messages::Message.new(:messageType => Messages::Message::MessageType::ExecutionStatusResponse, :messageId => message.messageId, :executionStatusResponse => execution_status_response)
    end
  end
end