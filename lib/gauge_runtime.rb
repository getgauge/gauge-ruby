=begin
 *  Copyright (c) ThoughtWorks, Inc.
 *  Licensed under the Apache License, Version 2.0
 *  See LICENSE.txt in the project root for license information.
=end
require 'socket'
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
