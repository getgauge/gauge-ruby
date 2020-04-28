=begin
 *  Copyright (c) ThoughtWorks, Inc.
 *  Licensed under the Apache License, Version 2.0
 *  See LICENSE.txt in the project root for license information.
=end
module Gauge
  module Processors
    def process_step_name_request(request)
      step_value = request.stepValue
      unless MethodCache.valid_step?(step_value)
        return Messages::StepNameResponse.new(isStepPresent: false, stepName: [""], hasAlias: false, fileName: "", span: nil)
      end
      step_text = MethodCache.get_step_text(step_value)
      has_alias = MethodCache.has_alias?(step_text)
      loc = MethodCache.get_step_info(step_value)[:locations][0]
      span = Gauge::Messages::Span.new(start: loc[:span].begin.line, end: loc[:span].end.line, startChar: loc[:span].begin.column, endChar: loc[:span].end.column)
      Messages::StepNameResponse.new(isStepPresent: true, stepName: [step_text], hasAlias: has_alias, fileName: loc[:file], span: span)
    end
  end
end
