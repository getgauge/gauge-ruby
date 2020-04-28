=begin
 *  Copyright (c) ThoughtWorks, Inc.
 *  Licensed under the Apache License, Version 2.0
 *  See LICENSE.txt in the project root for license information.
=end
require_relative '../util'

module Gauge
  module Processors
    def process_implementation_glob_pattern_request(_request)
      implPath = Util.get_step_implementation_dir
      Messages::ImplementationFileGlobPatternResponse.new(globPatterns: ["#{implPath}/**/*.rb"])
    end
  end
end
