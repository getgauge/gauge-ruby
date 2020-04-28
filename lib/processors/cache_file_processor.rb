# frozen_string_literal: true
=begin
 *  Copyright (c) ThoughtWorks, Inc.
 *  Licensed under the Apache License, Version 2.0
 *  See LICENSE.txt in the project root for license information.
=end
require_relative '../static_loader'
require_relative '../method_cache'
module Gauge
  # @api private
  module Processors
    def process_cache_file_request(request)
      f = request.filePath
      status =  Messages::CacheFileRequest::FileStatus.resolve(request.status)
      if (status == Messages::CacheFileRequest::FileStatus::CHANGED) || (status == Messages::CacheFileRequest::FileStatus::OPENED)
        ast = CodeParser.code_to_ast(request.content)
        StaticLoader.reload_steps(f, ast)
      elsif status == Messages::CacheFileRequest::FileStatus::CREATED
        if !Gauge::MethodCache.is_file_cached f
          ast = CodeParser.code_to_ast File.read(f)
          StaticLoader.reload_steps(f, ast)
        end
      elsif (status == Messages::CacheFileRequest::FileStatus::CLOSED) && File.file?(f)
        ast = CodeParser.code_to_ast File.read(f)
        StaticLoader.reload_steps(f, ast)
      else
        StaticLoader.remove_steps(f)
      end
      Messages::Empty.new
    end
  end
end
