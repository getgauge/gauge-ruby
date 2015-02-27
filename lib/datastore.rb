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
  # @api public
  class DataStore

    # @api private
    def initialize
      clear
    end

    # Fetches the object corresponding to the given key
    # @param key [string], the key for retrieving object.
    # @return [object]
    def get(key)
      @data_map[key]
    end

    # Stores the object against the given key
    # @param key [string], the key for storing the object, has to be unique
    # @param value [object], the object to be persisted
    def put(key, value)
      @data_map[key] = value
    end

    # @api private
    def clear
      @data_map = Hash.new
    end
  end


  # @api public
  class DataStoreFactory
    # Gets a datastore, that lives throughout the suite execution
    # @example
    #   DataStoreFactory.suite_datastore.put("foo", {:name=>"foo"})
    #   DataStoreFactory.suite_datastore.get("foo")
    #   => {:name=>"foo"}
    def self.suite_datastore
      return @@suite_datastore
    end

    # Gets a datastore, that lives throughout a specification execution
    # This is purged after every specification execution.
    # @example
    #   DataStoreFactory.scenario_datastore.put("foo", {:name=>"foo"})
    #   DataStoreFactory.scenario_datastore.get("foo")
    #   => {:name=>"foo"}
    def self.spec_datastore
      return @@spec_datastore
    end

    # Gets a datastore, that lives throughout a scenario execution
    # This is purged after every scenario execution.
    # @example
    #   DataStoreFactory.scenario_datastore.put("foo", {:name=>"foo"})
    #   DataStoreFactory.scenario_datastore.get("foo")
    #   => {:name=>"foo"}
    def self.scenario_datastore
      return @@scenario_datastore
    end

    private
    @@suite_datastore = DataStore.new
    @@spec_datastore = DataStore.new
    @@scenario_datastore = DataStore.new
  end
end