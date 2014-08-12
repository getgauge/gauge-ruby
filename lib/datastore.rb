class DataStore

  def initialize
    clear
  end

  def get(key)
    @dataMap[key]
  end

  def put(key, value)
    @dataMap[key] = value
  end

  def clear
    @dataMap = Hash.new
  end
end


class DataStoreFactory
  @@suiteDataStore = DataStore.new
  @@specDataStore = DataStore.new
  @@scenarioDataStore = DataStore.new

  def self.getSuiteDataStore
    return @@suiteDataStore
  end

  def self.getSpecDataStore
    return @@specDataStore
  end

  def self.getScenarioDataStore
    return @@scenarioDataStore
  end
end

