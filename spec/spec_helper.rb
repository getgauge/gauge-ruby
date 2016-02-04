require 'simplecov'
require 'rspec'
require 'method_source'
SimpleCov.start{
  add_filter '/spec/'
}

Dir.glob('lib/**/*.rb')
  .reject{|f| f.end_with?'gauge_runtime.rb'}
  .each{|f| require_relative "../#{f}"}
