# Gauge-ruby

[![Actions Status](https://github.com/getgauge/gauge-ruby/workflows/tests/badge.svg)](https://github.com/getgauge/gauge-ruby/actions)
[![Gem](https://img.shields.io/gem/v/gauge-ruby.svg)](https://rubygems.org/gems/gauge-ruby)
[![Download Nightly](https://api.bintray.com/packages/gauge/gauge-ruby/Nightly/images/download.svg) ](https://bintray.com/gauge/gauge-ruby/Nightly/_latestVersion)
[![Contributor Covenant](https://img.shields.io/badge/Contributor%20Covenant-v1.4%20adopted-ff69b4.svg)](CODE_OF_CONDUCT.md)

This project adds ruby [language plugin](https://docs.gauge.org/plugins.html#language-reporting-plugins) for [gauge](http://getgauge.io).

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
gauge install ruby --version 0.4.2
```

#### Offline installation

* Download the plugin from [Releases](https://github.com/getgauge/gauge-ruby/releases)
```
gauge install ruby --file gauge-ruby-0.4.2-linux.x86_64.zip
```

#### Nightly installation

To install ruby nightly, download the latest nightly from [here](https://bintray.com/gauge/gauge-ruby/Nightly).

Once you have the downloaded nightly gauge-ruby-version.nightly-yyyy-mm-dd.zip, install using:

    gauge install ruby -f gauge-ruby-version.nightly-yyyy-mm-dd.zip


#### Build from Source

##### Requirements
* [Golang](http://golang.org/)
* [Ruby](https://www.ruby-lang.org/en/)
* [Bundler](http://bundler.io/)
* [Gauge](http://getgauge.io)

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

For distributable across platforms os, windows and linux for bith x86 and x86_64

````
bundle exec rake package_all
````

New distribution details need to be updated in the ruby-install.json file in  [gauge plugin repository](https://github.com/getgauge/gauge-repository) for a new verison update.

## License

![GNU Public License version 3.0](http://www.gnu.org/graphics/gplv3-127x51.png)
Gauge-Ruby is released under [GNU Public License version 3.0](http://www.gnu.org/licenses/gpl-3.0.txt)

## Copyright

Copyright 2015 ThoughtWorks, Inc.

