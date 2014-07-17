require 'socket'
require 'protocol_buffers'

require_relative 'messages.pb'
require_relative 'executor'
require_relative 'connector'
require_relative 'message-processor'

HOST_NAME = 'localhost'

DEFAULT_IMPLEMENTATIONS_DIR_PATH = File.join(Dir.pwd, 'step_implementations')

def dispatch_messages(socket)
  while (!socket.eof?)
    len = Connector.message_length(socket)
    data = socket.read len
    message = Main::Message.parse(data)
    handle_message(socket, message)
    if (message.messageType == Main::Message::MessageType::KillProcessRequest || message.messageType == Main::Message::MessageType::ExecutionEnding)
      socket.close
      return
    end
  end
end


def handle_message(socket, message)
  if (!MessageProcessor.is_valid_message(message))
    puts "Invalid message received : #{message}"
  else
    response = MessageProcessor.process_message message
    write_message(socket, response)
  end
end

def write_message(socket, message)
  serialized_message = message.to_s
  size = serialized_message.bytesize
  ProtocolBuffers::Varint.encode(socket, size)
  socket.write serialized_message
end

def portFromEnvVariable(envVariable)
  port = ENV[envVariable]
  if (port.nil?)
    raise RuntimeError, "Could not find Env variable :#{envVariable}"
  end
  return port
end

STDOUT.sync = true
Connector.make_connections()
load_steps(DEFAULT_IMPLEMENTATIONS_DIR_PATH)
dispatch_messages(Connector.executionSocket)

