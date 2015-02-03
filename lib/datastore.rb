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