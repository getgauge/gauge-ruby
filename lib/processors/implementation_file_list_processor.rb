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

require_relative '../util'

module Gauge
  module Processors
    def process_implementation_file_list_request(message)
      r = implementation_files()
      Messages::Message.new(:messageType => :ImplementationFileListResponse, :messageId => message.messageId, :implementationFileListResponse => r)
    end

    def implementation_files()
      implPath = Util.get_step_implementation_dir
      fileList = Dir["#{implPath}/**/*.rb"]
      Messages::ImplementationFileListResponse.new(:implementationFilePaths => fileList)
    end
  end
end