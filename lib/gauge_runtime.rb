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

require 'socket'
require 'protocol_buffers'

require_relative 'messages.pb'
require_relative 'executor'
require_relative 'connector'
require_relative 'message_processor'


module Gauge
  # @api private
  module Runtime
    DEFAULT_IMPLEMENTATIONS_DIR_PATH = File.join(Dir.pwd, 'step_implementations')

    def self.dispatch_messages(socket)
      while (!socket.eof?)
        len = Connector.message_length(socket)
        data = socket.read len
        message = Messages::Message.parse(data)
        handle_message(socket, message)
        if (message.messageType == Messages::Message::MessageType::KillProcessRequest || message.messageType == Messages::Message::MessageType::ExecutionEnding)
          socket.close
          return
        end
      end
    end


    def self.handle_message(socket, message)
      if (!MessageProcessor.is_valid_message(message))
        puts "Invalid message received : #{message}"
        execution_status_response = Messages::ExecutionStatusResponse.new(:executionResult => Messages::ProtoExecutionResult.new(:failed => true, :executionTime => 0))
        message = Messages::Message.new(:messageType => Messages::Message::MessageType::ExecutionStatusResponse, :messageId => message.messageId, :executionStatusResponse => execution_status_response)
        write_message(socket, message)
      else
        response = MessageProcessor.process_message message
        write_message(socket, response)
      end
    end

    def self.write_message(socket, message)
      serialized_message = message.to_s
      size = serialized_message.bytesize
      ProtocolBuffers::Varint.encode(socket, size)
      socket.write serialized_message
    end

    def self.portFromEnvVariable(envVariable)
      port = ENV[envVariable]
      if (port.nil?)
        raise RuntimeError, "Could not find Env variable :#{envVariable}"
      end
      return port
    end

    STDOUT.sync = true
    Connector.make_connections()
    Executor.load_steps(DEFAULT_IMPLEMENTATIONS_DIR_PATH)
    dispatch_messages(Connector.executionSocket)
    exit(0)
  end
end
