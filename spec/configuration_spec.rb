require 'rspec'
require_relative '../lib/configuration.rb'

module Foo
  def hello_foo
    "hello_foo"
  end
end

module Bar
  def hello_bar
    "hello_bar"
  end
end

module Baz
end


describe Gauge::Configuration do
  before(:each) {
    Gauge.configure do |c|
      c.include Foo, Bar
    end
    Gauge::Configuration.include_configured_modules
  }

  it ".configure" do
    expect(Gauge::Configuration.instance.includes).to include Foo, Bar
    expect(hello_foo).to eq "hello_foo"
    expect(hello_bar).to eq "hello_bar"
  end

  context "multiple configs" do
    it "aggregates includes" do
      Gauge.configure { |c| c.include Baz}
      expect(Gauge::Configuration.instance.includes).to include Foo, Bar, Baz
    end
  end
end