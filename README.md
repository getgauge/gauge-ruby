# gauge-ruby

[![Build Status](https://travis-ci.org/getgauge/gauge-ruby.svg?branch=master)](https://travis-ci.org/getgauge/gauge-ruby)
[![Gem](https://img.shields.io/gem/v/gauge-ruby.svg)](https://rubygems.org/gems/gauge-ruby)
[![Download Nightly](https://api.bintray.com/packages/gauge/gauge-ruby/Nightly/images/download.svg) ](https://bintray.com/gauge/gauge-ruby/Nightly/_latestVersion)

This is the ruby [language plugin](http://getgauge.io/documentation/user/current/plugins/README.html) for [gauge](http://getgauge.io).

It contains a launcher component (gauge-ruby.go) written in golang which is used to start the plugin from gauge.

## Install through Gauge

````
gauge install ruby
````

* Installing specific version
```
gauge install ruby --version 0.4.2
```

### Offline installation

* Download the plugin from [Releases](https://github.com/getgauge/gauge-ruby/releases)
```
gauge install ruby --file gauge-ruby-0.4.2-linux.x86_64.zip
```

## Build from Source

### Requirements
* [Golang](http://golang.org/)
* [Ruby](https://www.ruby-lang.org/en/)
* [Gauge](http://getgauge.io)


Running `rake -T` should give the list of all tasks available. Below sections detail some commonly used tasks.

### Compiling

To build gauge-ruby.xxx.gem and the gauge-ruby executable for current platform use:

````
rake compile
````

To build gauge-ruby.xxx.gem and the gauge-ruby for all supported platforms use:

````
rake xcompile
````

### Installing

After compiling

TO install the gauge-ruby.xxx.gem use:

````
rake install
````

To install gauge-ruby plugin use (Note, this will uninstall gauge-ruby before installing the compiled version):

```
rake force_install
```

Installing to a CUSTOM_LOCATION

````
rake force_install[CUSTOM_LOCATION]
````

### Creating distributable


Note: Run after compiling

````
rake package
````

For distributable across platforms os, windows and linux for bith x86 and x86_64

````
rake package_all
````

New distribution details need to be updated in the ruby-install.json file in  [gauge plugin repository](https://github.com/getgauge/gauge-repository) for a new verison update.

## License

![GNU Public License version 3.0](http://www.gnu.org/graphics/gplv3-127x51.png)
Gauge-Ruby is released under [GNU Public License version 3.0](http://www.gnu.org/licenses/gpl-3.0.txt)

## Copyright

Copyright 2015 ThoughtWorks, Inc.

