module Gauge
  class << self
    def configure(&block)
      Configuration.instance.instance_eval &block
    end
  end

  class Configuration
    def initialize
      @includes=[]
    end

    def self.instance
      @configuration ||= Configuration.new
    end

    def include(*includes)
      @includes.push *includes
    end

    def includes
      @includes
    end
  end
end