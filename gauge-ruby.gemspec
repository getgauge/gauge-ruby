require 'json'
Gem::Specification.new do |s|
    s.name        = "gauge-ruby"
    s.version     = JSON.parse(File.read('ruby.json'))['version']
    s.authors     = ["Gauge Team"]
    s.email       = ["gauge@thoughtworks.com"]
    s.license     = "Apache-2.0"

    s.summary     = "Ruby support for Gauge"
    s.description = "Adds Ruby support into Gauge tests"
    s.homepage    = "https://gauge.org"
    s.files = Dir.glob("lib/**/*.rb")

    s.add_runtime_dependency 'ruby-protocol-buffers', '1.6.1'
    s.add_runtime_dependency 'parser', '>= 2.7', '< 4.0'
    s.add_runtime_dependency 'unparser', '>= 0.5.0', '< 0.7.0'
    s.add_runtime_dependency 'grpc', '~> 1.10', '>= 1.10.0'
    s.add_development_dependency 'grpc-tools', '~> 1.10', '>= 1.10.0'
    s.required_ruby_version = ">= 2.7" if s.respond_to? :required_ruby_version=
    s.required_rubygems_version = ">= 2.7" if s.respond_to? :required_rubygems_version=
end
