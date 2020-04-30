=begin
 *  Copyright (c) ThoughtWorks, Inc.
 *  Licensed under the Apache License, Version 2.0
 *  See LICENSE.txt in the project root for license information.
=end
require_relative '../../lib/util'

module Gauge
  module Processors
    def process_stub_implementation_code_request(request)
      codes = request.codes
      file_path = request.implementationFilePath
      content = ''
      if File.file? file_path
        content = File.read(file_path)
      else
        file_path = Util.get_file_name
      end
      text_diffs = [Messages::TextDiff.new(span: create_span(content, codes), content: codes.join("\n"))]
      Messages::FileDiff.new(filePath: file_path, textDiffs: text_diffs)
    end

    private
    def create_span(content, codes)
      unless content.empty?
        eof_char = content.strip.length == content.length ? "\n" : ''
        codes.unshift(eof_char)
        line = content.split("\n").length
        return Messages::Span.new(start: line, startChar: 0, end: line, endChar: 0)
      end
      Messages::Span.new(start: 0, startChar: 0, end: 0, endChar: 0)
    end
  end
end
