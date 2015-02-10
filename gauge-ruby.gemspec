Gem::Specification.new do |s|
    s.name        = "gauge-ruby"
    s.version     = '0.0.4'
    s.authors     = ["Gauge Team"]
    s.email       = ["gauge@thoughtworks.com"]
    s.license     = "GPLv3"

    s.summary     = "Ruby support for Gauge"
    s.description = "Adds Ruby support into Gauge tests"
    s.homepage    = "http://www.getgauge.io"
    s.files = Dir.glob("lib/**/*.rb")
    s.has_rdoc = 'yard'
    
    s.add_runtime_dependency 'ruby-protocol-buffers', '1.5.1'
    s.add_runtime_dependency 'os', '0.9.6'
    s.add_runtime_dependency 'parser', '~> 2.2'
    s.add_runtime_dependency 'method_source', '~> 0.8.2'
end
