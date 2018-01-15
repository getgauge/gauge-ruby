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

module Gauge
  module Processors
    def process_step_positions_request(message)
      file = message.stepPositionsRequest.filePath
      positions = MethodCache.step_positions(file)
      p = create_step_position_messages(positions)
      r = Messages::StepPositionsResponse.new(:stepPositions => p)
      Messages::Message.new(:messageType => Messages::Message::MessageType::StepPositionsResponse, :messageId => message.messageId, :stepPositionsResponse => r)
    end

    def create_step_position_messages(positions)
      positions.map do |p|
        span = Gauge::Messages::Span.new(:start => p[:span].begin.line, :end => p[:span].end.line, :startChar => p[:span].begin.column, :endChar => p[:span].end.column)
        Messages::StepPositionsResponse::StepPosition.new(:stepValue => p[:stepValue], :span => span)
      end
    end
  end
end