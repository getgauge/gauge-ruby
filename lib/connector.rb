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

require 'protocol_buffers'
require_relative 'api.pb'

module Gauge
  # @api private
  module Connector
    GAUGE_PORT_ENV = "GAUGE_INTERNAL_PORT"
    API_PORT_ENV = "GAUGE_API_PORT"
    HOST_NAME = 'localhost'
    @@executionSocket = nil
    @@apiSocket = nil

    def self.apiSocket
      @@apiSocket
    end

    def self.executionSocket
      @@executionSocket
    end

    def self.make_connections
      @@executionSocket = TCPSocket.open(HOST_NAME, Runtime.portFromEnvVariable(GAUGE_PORT_ENV))
      @@apiSocket = TCPSocket.open(HOST_NAME, Runtime.portFromEnvVariable(API_PORT_ENV))
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
end
