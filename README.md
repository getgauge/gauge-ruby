# Gauge-ruby

[![Actions Status](https://github.com/getgauge/gauge-ruby/workflows/tests/badge.svg)](https://github.com/getgauge/gauge-ruby/actions)
[![Gem](https://img.shields.io/gem/v/gauge-ruby.svg)](https://rubygems.org/gems/gauge-ruby)
[![Contributor Covenant](https://img.shields.io/badge/Contributor%20Covenant-v1.4%20adopted-ff69b4.svg)](CODE_OF_CONDUCT.md)

This project adds ruby [language plugin](https://docs.gauge.org/plugins.html#language-reporting-plugins) for [gauge](https://gauge.org/).

The plugin is authored in [Ruby](https://en.wikipedia.org/wiki/Ruby_(programming_language)). It contains a launcher component (gauge-ruby.go) written in golang which is used to start the plugin from [gauge](https://github.com/getgauge/gauge).

## Getting started

### Pre-requisite

- [Install Gauge](https://docs.gauge.org/installing.html#installation)

### Installation

```
gauge install ruby
```

### Create a gauge-ruby project

```
gauge init ruby
```

### Run tests

```
gauge run specs
```

### Alternate Installation options

#### Install specific version
* Installing specific version
```
gauge install ruby --version 0.7.0
```

#### Offline installation

* Download the plugin from [Releases](https://github.com/getgauge/gauge-ruby/releases)
```
gauge install ruby --file gauge-ruby-0.7.0-linux.x86_64.zip
```

#### Build from Source

##### Requirements
* [Golang](http://golang.org/)
* [Ruby](https://www.ruby-lang.org/en/)
* [Bundler](http://bundler.io/)
* [Gauge](https://gauge.org/)

Run `bundle install` to install all required gems.

Running `bundle exec rake -T` should give the list of all tasks available. Below sections detail some commonly used tasks.

##### Compiling

To build gauge-ruby.xxx.gem and the gauge-ruby executable for current platform use:

````
bundle exec rake compile
````

To build gauge-ruby.xxx.gem and the gauge-ruby for all supported platforms use:

````
bundle exec rake xcompile
````

##### Installing

After compiling

TO install the gauge-ruby.xxx.gem use:

````
bundle exec rake install
````

To install gauge-ruby plugin use (Note, this will uninstall gauge-ruby before installing the compiled version):

```
bundle exec rake force_install
```

Installing to a CUSTOM_LOCATION

````
bundle exec rake force_install[CUSTOM_LOCATION]
````

##### Creating distributable

Note: Run after compiling

````
bundle exec rake package
````

For distributable across platforms os, windows and linux for both x86_64 and arm64

````
bundle exec rake package_all
````

New distribution details need to be updated in the ruby-install.json file in  [gauge plugin repository](https://github.com/getgauge/gauge-repository) for a new version update.

## License

[Apache License, Version 2.0](https://www.apache.org/licenses/LICENSE-2.0)

## Copyright

Copyright ThoughtWorks, Inc.

