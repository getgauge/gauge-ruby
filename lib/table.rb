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
  # Holds a table definition. This corresponds to a markdown table defined in the .spec files.
  # @api public
  class Table
    # @api private
    def initialize(protoTable)
      @columns = protoTable.headers.cells
      @rows = []
      protoTable.rows.each do |row|
          @rows.push row.cells
      end
    end

    # Gets the column headers of the table
    # @return [string[]]
    def columns
      @columns
    end

    # Gets the rows of the table. The rows are two dimensional arrays.
    # @return [string[][]]
    def rows
      @rows
    end
  end
end