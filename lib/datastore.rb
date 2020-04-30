=begin
 *  Copyright (c) ThoughtWorks, Inc.
 *  Licensed under the Apache License, Version 2.0
 *  See LICENSE.txt in the project root for license information.
=end
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
