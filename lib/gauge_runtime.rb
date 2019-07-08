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

require 'socket'
require 'protocol_buffers'
require 'grpc'

require_relative 'messages_pb'
require_relative 'executor'
require_relative 'static_loader'
require_relative 'connector'
require_relative 'message_processor'
require_relative 'util'
require_relative 'log'
require_relative 'lsp_server'

module Gauge
  # @api private
  module Runtime
    DEFAULT_IMPLEMENTATIONS_DIR_PATH = Util.get_step_implementation_dir

    def self.dispatch_messages(socket)
      until socket.eof?
        len = Connector.message_length(socket)
        data = socket.read len
        message = Messages::Message.decode(data)
        handle_message(socket, message)
        if message.messageType == :KillProcessRequest || message.messageType == :ExecutionEnding
          socket.close
          return
        end
      end
    end

    def self.handle_message(socket, message)
      if !MessageProcessor.is_valid_message(message)
        GaugeLog.error "Invalid message received : #{message}"
        execution_status_response = Messages::ExecutionStatusResponse.new(executionResult: Messages::ProtoExecutionResult.new(failed: true, executionTime: 0))
        message = Messages::Message.new(messageType: :ExecutionStatusResponse, messageId: message.messageId, executionStatusResponse: execution_status_response)
        write_message(socket, message)
      else
        response = MessageProcessor.process_message message
        write_message(socket, response) if response
      end
    end

    def self.write_message(socket, message)
      serialized_message = Messages::Message.encode(message)
      size = serialized_message.bytesize
      ProtocolBuffers::Varint.encode(socket, size)
      socket.write serialized_message
    end

    def self.port_from_env_variable(env_variable)
      port = ENV[env_variable]
      raise "Could not find Env variable :#{env_variable}" if port.nil?
      port
    end

    STDOUT.sync = true
    StaticLoader.load_files(DEFAULT_IMPLEMENTATIONS_DIR_PATH)
    if ENV.key? 'GAUGE_LSP_GRPC'
      GaugeLog.debug 'Starting grpc server..'
      server = GRPC::RpcServer.new
      p = server.add_http2_port('127.0.0.1:0', :this_port_is_insecure)
      server.handle(Gauge::LSPServer.new(server))
      GaugeLog.info "Listening on port #{p}"
      server.run_till_terminated
    else
      GaugeLog.debug('Starting TCP server..')
      Connector.make_connection
      dispatch_messages(Connector.execution_socket)
    end
    exit(0)
  end
end
