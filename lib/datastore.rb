# Copyright 2014 ThoughtWorks, Inc.

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
  class DataStore

    def initialize
      clear
    end

    def get(key)
      @data_map[key]
    end

    def put(key, value)
      @data_map[key] = value
    end

    def clear
      @data_map = Hash.new
    end
  end


  class DataStoreFactory
    @@suite_datastore = DataStore.new
    @@spec_datastore = DataStore.new
    @@scenario_datastore = DataStore.new

    def self.suite_datastore
      return @@suite_datastore
    end

    def self.spec_datastore
      return @@spec_datastore
    end

    def self.scenario_datastore
      return @@scenario_datastore
    end
  end
end