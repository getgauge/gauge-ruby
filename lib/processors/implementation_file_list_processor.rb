=begin
 *  Copyright (c) ThoughtWorks, Inc.
 *  Licensed under the Apache License, Version 2.0
 *  See LICENSE.txt in the project root for license information.
=end
require_relative '../util'

module Gauge
  module Processors
    def process_implementation_file_list_request(_request)
      implPath = Util.get_step_implementation_dir
      fileList = Dir["#{implPath}/**/*.rb"]
      Messages::ImplementationFileListResponse.new(:implementationFilePaths => fileList)
    end
  end
end
