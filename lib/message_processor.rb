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

require_relative 'messages_pb'
require_relative 'executor'
require_relative 'table'
Dir[File.join(File.dirname(__FILE__), 'processors/*.rb')].each {|file| require file}

module Gauge
  # @api private
  class MessageProcessor
    extend Processors

    @processors = Hash.new

    @processors[:StepValidateRequest] = method(:process_step_validation_request)
    @processors[:ExecutionStarting] = method(:process_execution_start_request)
    @processors[:ExecutionEnding] = method(:process_execution_end_request)
    @processors[:SpecExecutionStarting] = method(:process_spec_execution_start_request)
    @processors[:SpecExecutionEnding] = method(:process_spec_execution_end_request)
    @processors[:ScenarioExecutionStarting] = method(:process_scenario_execution_start_request)
    @processors[:ScenarioExecutionEnding] = method(:process_scenario_execution_end_request)
    @processors[:StepExecutionStarting] = method(:process_step_execution_start_request)
    @processors[:StepExecutionEnding] = method(:process_step_execution_end_request)
    @processors[:ExecuteStep] = method(:process_execute_step_request)
    @processors[:StepNamesRequest] = method(:process_step_names_request)
    @processors[:KillProcessRequest] = method(:process_kill_processor_request)
    @processors[:SuiteDataStoreInit] = method(:process_datastore_init)
    @processors[:SpecDataStoreInit] = method(:process_datastore_init)
    @processors[:ScenarioDataStoreInit] = method(:process_datastore_init)
    @processors[:StepNameRequest] = method(:process_step_name_request)
    @processors[:RefactorRequest] = method(:refactor_step)
    @processors[:CacheFileRequest] = method(:process_cache_file_request)
    @processors[:StepPositionsRequest] = method(:process_step_positions_request)
    @processors[:ImplementationFileListRequest] = method(:process_implementation_file_list_request)
    @processors[:ImplementationFileGlobPatternRequest] = method(:process_implementation_glob_pattern_request)
    @processors[:StubImplementationCodeRequest] = method(:process_stub_implementation_code_request)

    def self.is_valid_message(message)
      return @processors.has_key? message.messageType
    end

    def self.process_message(message)
      @processors[message.messageType].call message
    end
  end
end