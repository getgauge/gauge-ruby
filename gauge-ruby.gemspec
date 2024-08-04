require 'json'
Gem::Specification.new do |s|
    s.name        = "gauge-ruby"
    s.version     = JSON.parse(File.read('ruby.json'))['version']
    s.authors     = ["Gauge Team"]
    s.email       = ["getgauge@googlegroups.com"]
    s.license     = "Apache-2.0"
    s.metadata = {
      "bug_tracker_uri"   => "https://github.com/getgauge/gauge-ruby/issues",
      "documentation_uri" => "https://docs.gauge.org/",
      "homepage_uri"      => "https://gauge.org/",
      "mailing_list_uri"  => "https://github.com/getgauge/gauge/discussions",
      "source_code_uri"   => "https://github.com/getgauge/gauge-ruby"
    }

    s.summary     = "Ruby support for Gauge"
    s.description = "Adds Ruby support into Gauge tests"
    s.homepage    = "https://gauge.org"
    s.files = Dir.glob("lib/**/*.rb")

    s.add_runtime_dependency 'parser', '>= 3.1', '< 4.0'
    s.add_runtime_dependency 'unparser', '>= 0.6.4', '< 0.7.0'
    s.add_runtime_dependency 'grpc', '~> 1.10', '>= 1.10.0', '< 1.65'
    s.add_development_dependency 'grpc-tools', '~> 1.10', '>= 1.10.0', '< 1.66'
    s.required_ruby_version = ">= 3.1"
end
