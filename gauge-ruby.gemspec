require 'json'
Gem::Specification.new do |s|
    s.name        = "gauge-ruby"
    s.version     = JSON.parse(File.read('ruby.json'))['version']
    s.authors     = ["Gauge Team"]
    s.email       = ["gauge@thoughtworks.com"]
    s.license     = "GPL-3.0"

    s.summary     = "Ruby support for Gauge"
    s.description = "Adds Ruby support into Gauge tests"
    s.homepage    = "http://www.getgauge.io"
    s.files = Dir.glob("lib/**/*.rb")

    s.add_runtime_dependency 'ruby-protocol-buffers', '1.6.1'
    s.add_runtime_dependency 'os', '1.1.1'
    s.add_runtime_dependency 'parser', '~> 2.3'
    s.add_runtime_dependency 'unparser', '>= 0.2.6', '< 0.6.0'
    s.add_runtime_dependency 'method_source', '>= 0.8.2', '< 1.1.0'
    s.add_runtime_dependency 'ruby-debug-ide', '>=0.6', '<0.8'
    s.add_runtime_dependency 'debase', '~>0.2.2'
    s.add_runtime_dependency 'grpc', '~> 1.10', '>= 1.10.0'
    s.add_development_dependency 'grpc-tools', '~> 1.10', '>= 1.10.0'
    s.required_ruby_version = ">= 1.9" if s.respond_to? :required_ruby_version=
    s.required_rubygems_version = ">= 1.9" if s.respond_to? :required_rubygems_version=
end
