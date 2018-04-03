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
    def process_step_name_request(message)
      r = step_name_response(message.stepNameRequest)
      Messages::Message.new(messageType: :StepNameResponse, messageId: message.messageId, stepNameResponse: r)
    end

    def step_name_response(request)
      step_value = request.stepValue
      unless MethodCache.valid_step?(step_value)
        return Messages::StepNameResponse.new(isStepPresent: false, stepName: [''], hasAlias: false, fileName: '', span: nil)
      end
      step_text = MethodCache.get_step_text(step_value)
      has_alias = MethodCache.has_alias?(step_text)
      loc = MethodCache.get_step_info(step_value)[:locations][0]
      span = Gauge::Messages::Span.new(start: loc[:span].begin.line, end: loc[:span].end.line, startChar: loc[:span].begin.column, endChar: loc[:span].end.column)
      Messages::StepNameResponse.new(isStepPresent: true, stepName: [step_text], hasAlias: has_alias, fileName: loc[:file], span: span)
    end
  end
end
