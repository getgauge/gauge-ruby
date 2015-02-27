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

module Gauge
  module Processors
    def process_step_name_request(message)
      parsed_step_text = message.stepNameRequest.stepValue
      is_valid = MethodCache.valid_step?(parsed_step_text)
      step_text = is_valid ? MethodCache.get_step_text(parsed_step_text) : ""
      has_alias = MethodCache.has_alias?(step_text)
      get_step_name_response = Messages::StepNameResponse.new(isStepPresent: is_valid, stepName: [step_text], hasAlias: has_alias)
      Messages::Message.new(:messageType => Messages::Message::MessageType::StepNameResponse, :messageId => message.messageId, :stepNameResponse => get_step_name_response)
    end
  end
end