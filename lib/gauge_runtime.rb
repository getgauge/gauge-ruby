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
require_relative 'util'
require_relative 'log'
require_relative 'service_handlers'

module Gauge
  module Runtime
    DEFAULT_IMPLEMENTATIONS_DIR_PATH = Util.get_step_implementation_dir

    STDOUT.sync = true
    StaticLoader.load_files(DEFAULT_IMPLEMENTATIONS_DIR_PATH)
    GaugeLog.debug 'Starting grpc server..'
    server = GRPC::RpcServer.new
    port = server.add_http2_port('127.0.0.1:0', :this_port_is_insecure)
    server.handle(Gauge::ExecutionHandler.new(server))
    GaugeLog.info "Listening on port:#{port}"
    server.run_till_terminated
    exit(0)
  end
end
