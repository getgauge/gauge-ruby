# Copyright 2015 ThoughtWorks, Inc.

# This file is part of Gauge-Ruby.

# Gauge-Ruby is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.

# Gauge-Ruby is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with Gauge-Ruby.  If not, see <http://www.gnu.org/licenses/>.

require 'rspec'
require_relative '../lib/gauge.rb'

foo_block=-> { puts "foo" }
describe Gauge::MethodCache do
  subject { Gauge::MethodCache }
  it ".get_before_step_hooks" do
    subject.clear_hooks("before_step")
    before_step &foo_block
    expect(subject.get_before_step_hooks).to include(&foo_block)
  end

  it ".get_before_step_hooks_with_tags" do
    subject.clear_hooks("before_step")
    before_step(tags: ['tag1'], &foo_block)
    expect(subject.get_before_step_hooks).to include(&foo_block)
    expect(subject.get_before_step_hooks[0][:options]).to eq({tags: ['tag1'], operator: "AND"})
  end

  it ".get_before_spec_hooks" do
    subject.clear_hooks("before_spec")
    before_spec &foo_block
    expect(subject.get_before_spec_hooks).to include(&foo_block)
  end

  it ".get_before_spec_hooks_with_tags" do
    subject.clear_hooks("before_spec")
    before_spec({tags: %w(tag1 tag2), operator: 'OR'}, &foo_block)
    expect(subject.get_before_spec_hooks).to include(&foo_block)
    expect(subject.get_before_spec_hooks[0][:options]).to eq({tags: %w(tag1 tag2), operator: 'OR'})
  end

  it ".get_before_scenario_hooks" do
    subject.clear_hooks("before_scenario")
    before_scenario &foo_block
    expect(subject.get_before_scenario_hooks).to include(&foo_block)
  end

  it ".get_before_scenario_hooks_with_tags" do
    subject.clear_hooks("before_scenario")
    before_scenario({tags: %w(tag1 tag2 tag3), operator: 'OR'}, &foo_block)
    expect(subject.get_before_scenario_hooks).to include(&foo_block)
    expect(subject.get_before_scenario_hooks[0][:options]).to eq({tags: %w(tag1 tag2 tag3), operator: 'OR'})
  end

  it ".get_before_suite_hooks" do
    before_suite &foo_block
    expect(subject.get_before_suite_hooks).to include(&foo_block)
  end

  it ".get_after_step_hooks" do
    subject.clear_hooks("after_step")
    after_step &foo_block
    expect(subject.get_after_step_hooks).to include(&foo_block)
  end

  it ".get_after_step_hooks_with_tags" do
    subject.clear_hooks("after_step")
    after_step({tags: %w(tag1)}, &foo_block)
    expect(subject.get_after_step_hooks).to include(&foo_block)
    expect(subject.get_after_step_hooks[0][:options]).to eq({tags: %w(tag1), operator: 'AND'})
  end

  it ".get_after_spec_hooks" do
    subject.clear_hooks("after_spec")
    after_spec &foo_block
    expect(subject.get_after_spec_hooks).to include(&foo_block)
  end

  it ".get_after_spec_hooks_with_tags" do
    subject.clear_hooks("after_spec")
    after_spec({tags: %w(tag1), operator: "OR"}, &foo_block)
    expect(subject.get_after_spec_hooks).to include(&foo_block)
    expect(subject.get_after_spec_hooks[0][:options]).to eq({tags: %w(tag1), operator: 'OR'})
  end

  it ".get_after_scenario_hooks" do
    subject.clear_hooks("after_scenario")
    after_scenario &foo_block
    expect(subject.get_after_scenario_hooks).to include(&foo_block)
  end

  it ".get_after_scenario_hooks_with_tags" do
    subject.clear_hooks("after_scenario")
    after_scenario({tags: %w(tag1 tag5), operator: "AND"}, &foo_block)
    expect(subject.get_after_scenario_hooks).to include(&foo_block)
    expect(subject.get_after_scenario_hooks[0][:options]).to eq({tags: %w(tag1 tag5), operator: 'AND'})
  end

  it ".get_after_suite_hooks" do
    after_suite &foo_block
    expect(subject.get_after_suite_hooks).to include(&foo_block)
  end

  context "step definitions" do
    before(:each) {
      ["foo", "bar", "baz"].each { |v|
        allow(Gauge::Connector).to receive(:step_value).with(v).and_return("parameterized_#{v}")
      }
      step "foo", &foo_block
    }

    # used the should syntax here, since expectations on block does not seem to work.
    it ".get_step" do
      expect(subject.get_step("parameterized_foo")).to eq foo_block
    end

    it ".get_step_text" do
      expect(subject.get_step_text("parameterized_foo")).to eq "foo"
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
