require 'protocol_buffers'
require_relative 'api.pb'

module Connector
  GAUGE_PORT_ENV = "GAUGE_INTERNAL_PORT"
  API_PORT_ENV = "GAUGE_API_PORT"
  @@executionSocket
  @@apiSocket

  def self.apiSocket
    @@apiSocket
  end

  def self.executionSocket
    @@executionSocket
  end

  def self.make_connections
    @@executionSocket = TCPSocket.open(HOST_NAME, portFromEnvVariable(GAUGE_PORT_ENV))
    @@apiSocket = TCPSocket.open(HOST_NAME, portFromEnvVariable(API_PORT_ENV))
  end

  def self.message_length(socket)
    ProtocolBuffers::Varint.decode socket
  end

  def self.step_value text
    stepValueRequest = Gauge::Messages::GetStepValueRequest.new(:stepText => text)
    apiMessage = Gauge::Messages::APIMessage.new(:messageType => Gauge::Messages::APIMessage::APIMessageType::GetStepValueRequest, :stepValueRequest => stepValueRequest)
    response = get_api_response(apiMessage)
    if (response.messageType == Gauge::Messages::APIMessage::APIMessageType::ErrorResponse)
      puts "[Error] Failed to load step implementation. #{response.error.error}:  \"#{text}\""
      return ''
    end
    return response.stepValueResponse.stepValue.stepValue
  end

  def self.get_api_response(apiMessage)
    apiMessage.messageId = get_unique_id
    dataLen = apiMessage.serialize_to_string.bytesize
    ProtocolBuffers::Varint.encode @@apiSocket, dataLen
    apiMessage.serialize(@@apiSocket)

    responseLen = message_length(@@apiSocket)
    data = @@apiSocket.read responseLen
    message = Gauge::Messages::APIMessage.parse(data)
  end

  def self.get_unique_id
    rand(2**63-1)
  end
end