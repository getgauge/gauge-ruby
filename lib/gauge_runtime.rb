require 'socket'
require 'protocol_buffers'

require_relative 'messages.pb'
require_relative 'executor'
require_relative 'connector'
require_relative 'message_processor'

module Gauge
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
  end
end
