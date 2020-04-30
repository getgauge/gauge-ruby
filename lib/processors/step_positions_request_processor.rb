=begin
 *  Copyright (c) ThoughtWorks, Inc.
 *  Licensed under the Apache License, Version 2.0
 *  See LICENSE.txt in the project root for license information.
=end
module Gauge
  module Processors
    def process_step_positions_request(request)
      file = request.filePath
      positions = MethodCache.step_positions(file)
      p = create_step_position_messages(positions)
      Messages::StepPositionsResponse.new(:stepPositions => p)
    end

    def create_step_position_messages(positions)
      positions.map do |p|
        span = Gauge::Messages::Span.new(:start => p[:span].begin.line, :end => p[:span].end.line, :startChar => p[:span].begin.column, :endChar => p[:span].end.column)
        Messages::StepPositionsResponse::StepPosition.new(:stepValue => p[:stepValue], :span => span)
      end
    end
  end
end
