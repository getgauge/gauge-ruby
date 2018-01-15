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

require_relative '../static_loader'
require_relative '../method_cache'
module Gauge
  # @api private
  module Processors
    def process_cache_file_request(message)
      if !message.cacheFileRequest.isClosed
        ast = CodeParser.code_to_ast(message.cacheFileRequest.content)
        StaticLoader.reload_steps(message.cacheFileRequest.filePath, ast)
      else
        load_from_disk message.cacheFileRequest.filePath
      end
      nil
    end

    def load_from_disk(f)
      if File.file? f
        ast = CodeParser.code_to_ast File.read(f)
        StaticLoader.reload_steps(f, ast)
      else
        StaticLoader.remove_steps(f)
      end
    end

  end
end