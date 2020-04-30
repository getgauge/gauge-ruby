=begin
 *  Copyright (c) ThoughtWorks, Inc.
 *  Licensed under the Apache License, Version 2.0
 *  See LICENSE.txt in the project root for license information.
=end
module Gauge
  module Processors
    def process_step_names_request(_request)
      Messages::StepNamesResponse.new(steps: MethodCache.all_steps)
    end
  end
end
