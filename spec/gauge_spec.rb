require 'rspec'
require_relative '../lib/gauge.rb'

foo_block=->{puts "foo"}
describe Gauge::MethodCache do
  subject {Gauge::MethodCache}
  it ".get_before_step_hooks" do
    before_step &foo_block
    expect(subject.get_before_step_hooks).to include(&foo_block)
  end

  it ".get_before_spec_hooks" do
    before_spec &foo_block
    expect(subject.get_before_spec_hooks).to include(&foo_block)
  end

  it ".get_before_scenario_hooks" do
    before_scenario &foo_block
    expect(subject.get_before_scenario_hooks).to include(&foo_block)
  end

  it ".get_before_suite_hooks" do
    before_suite &foo_block
    expect(subject.get_before_suite_hooks).to include(&foo_block)
  end

  it ".get_after_step_hooks" do
    after_step &foo_block
    expect(subject.get_after_step_hooks).to include(&foo_block)
  end

  it ".get_after_spec_hooks" do
    after_spec &foo_block
    expect(subject.get_after_spec_hooks).to include(&foo_block)
  end

  it ".get_after_scenario_hooks" do
    after_scenario &foo_block
    expect(subject.get_after_scenario_hooks).to include(&foo_block)
  end

  it ".get_after_suite_hooks" do
    after_suite &foo_block
    expect(subject.get_after_suite_hooks).to include(&foo_block)
  end

  context "step definitions" do
    before(:each) {
      ["foo", "bar", "baz"].each{ |v|
        allow(Gauge::Connector).to receive(:step_value).with(v).and_return("parameterized_#{v}")
      }
      step "foo", &foo_block 
    }

    # used the should syntax here, since expectations on block does not seem to work.
    it ".get_step" do
      subject.get_step("parameterized_foo").should be foo_block
    end

    it ".get_step_text" do
      subject.get_step_text("parameterized_foo").should eq "foo"
    end

    context "step aliases" do
      it ".has_alias?" do
        step "bar", "baz", &foo_block
        ["bar", "baz"].each { |e|
          expect(subject.has_alias? e).to eq true
        }
      end
    end
  end
end

