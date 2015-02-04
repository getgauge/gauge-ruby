require 'rspec'
require_relative '../lib/configuration.rb'

describe Gauge::Configuration do
  before(:each) {
    Gauge.configure do |c|
      c.include "foo", "bar"
    end
  }

  it ".configure" do
    expect(Gauge::Configuration.instance.includes).to include "foo", "bar"
  end

  context "multiple configs" do
    it "aggregates includes" do
      Gauge.configure { |c| c.include "baz"}
      expect(Gauge::Configuration.instance.includes).to include "foo", "bar", "baz"
    end
  end
end