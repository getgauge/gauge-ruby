Gem::Specification.new do |s|
    s.name        = "gauge-ruby"
    s.version     = '0.0.3'
    s.authors     = ["Gauge Team"]
    s.email       = ["gauge@thoughtworks.com"]

    s.summary     = "Ruby support for Gauge"
    s.description = "Adds Ruby support into Gauge tests"
    s.homepage    = "http://www.getgauge.io"
    s.files = Dir.glob("lib/**/*.rb")
    s.add_runtime_dependency 'ruby-protocol-buffers', '1.5.1'
    s.add_runtime_dependency 'os', '0.9.6'
    s.add_runtime_dependency 'parser'
    s.add_runtime_dependency 'unparser'
end

