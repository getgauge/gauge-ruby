=begin
 *  Copyright (c) ThoughtWorks, Inc.
 *  Licensed under the Apache License, Version 2.0
 *  See LICENSE.txt in the project root for license information.
=end
require_relative '../code_parser'

module Gauge
  module Processors
    def process_refactor_request(request)
      response = Messages::RefactorResponse.new(success: true)
      begin
        step_info = get_step request.oldStepValue.stepValue
        refactored_info = CodeParser.refactor step_info, request.paramPositions, request.newStepValue
        file = step_info[:locations][0][:file]
        File.write file, refactored_info[:content] if request.saveChanges
        response.filesChanged.push(file)
        changes = Messages::FileChanges.new(fileName: file, fileContent: refactored_info[:content], diffs: refactored_info[:diffs])
        response.fileChanges.push(changes)
      rescue Exception => e
        response.success = false
        response.error = e.message
      end
      response
    end

    def get_step(step_text)
      md = MethodCache.multiple_implementation? step_text
      raise "Multiple step implementations found for => '#{step_text}'" if md
      MethodCache.get_step_info(step_text)
    end
  end
end
