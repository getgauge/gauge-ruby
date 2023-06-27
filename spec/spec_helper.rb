=begin
 *  Copyright (c) ThoughtWorks, Inc.
 *  Licensed under the Apache License, Version 2.0
 *  See LICENSE.txt in the project root for license information.
=end
require 'os'
require 'simplecov'
require 'rspec'
require 'method_source'
SimpleCov.start{
  add_filter '/spec/'
}

Dir.glob('lib/**/*.rb')
  .reject{|f| f.end_with?'gauge_runtime.rb'}
  .each{|f| require_relative "../#{f}"}
include Gauge::Processors
