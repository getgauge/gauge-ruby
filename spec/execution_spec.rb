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
require_relative '../lib/executor.rb'

describe Gauge::Executor do
  describe ".execute_hooks" do
    let(:execution_info) { double('execution_info') }
    let(:hook) {double('hook')}
    subject { Gauge::Executor.execute_hooks(hooks, execution_info, true) }

    before {
      allow(execution_info).to receive_message_chain(:currentSpec, :tags => ['tag1'])
      allow(execution_info).to receive_message_chain(:currentScenario, :tags => ['tag2', 'tag3'])
    }

    context "with no tags passed" do
      let(:hooks) {[{block: hook, options: {tags: [], operator: 'OR'}}]}

      context "on executing hook" do
        before { expect(hook).to receive(:call).with(execution_info)}
        it { is_expected.to be_nil }
      end

      context 'on executing hook that raises exception' do
        before { expect(hook).to receive(:call).with(execution_info).and_raise(Exception)}
        it { is_expected.to_not be_nil }
      end
    end

    context "when should_filter is false" do
      subject { Gauge::Executor.execute_hooks(hooks, execution_info, false) }
      let(:unmatched_hook) { double('unmatched_hook')}
      let(:hooks) {[
        {block: hook, options: {tags: %w(tag1), operator: 'AND'}},
        {block: unmatched_hook, options: {tags: %w(some random tags), operator: 'AND'}}
      ]}
      context "execute all hooks" do
        before { [hook, unmatched_hook].each { |h| expect(h).to receive(:call).with(execution_info)} }
        it { is_expected.to be_nil }
      end
    end

    describe "when OR-ing" do
      context "with tags passed" do
        let(:another_hook) {double('hook')}
        let(:hooks) {[
          {block: hook, options: {tags: ['tag1', 'tag_blah'], operator: 'OR'}},
          {block: another_hook, options: {tags: ['tag420'], operator: 'OR'}}
        ]}
        context 'executes hooks with matching tags' do
          before {
            expect(hook).to receive(:call).with(execution_info)
            expect(another_hook).to_not receive(:call)
          }
          it { is_expected.to be_nil}
        end
      end
    end

    describe "when AND-ing" do
      context "with tags passed" do
        before{
          allow(execution_info).to receive_message_chain(:currentSpec, :tags => ['tag1', 'tag2'])
          allow(execution_info).to receive_message_chain(:currentScenario, :tags => [])
        }
        describe "executes hooks with matching tags" do
          let(:another_hook) {double('hook')}
          let(:hooks) {[
            {block: hook, options: {tags: ['tag1', 'tag2'], operator: 'AND'}},
            {block: another_hook, options: {tags: ['tag1', 'tag420'], operator: 'AND'}}
          ]}
          before {
             expect(hook).to receive(:call).with(execution_info)
             expect(another_hook).to_not receive(:call)
          }
          it { is_expected.to be_nil}
        end
      end
    end
  end
end
