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


class Hook
  attr_accessor :called, :info

  def initialize()
    @called = false
    @info = nil
  end

  def call(info)
    @called = true
    @info = info
  end
end

Tags = Struct.new(:tags)
Info = Struct.new(:currentSpec, :currentScenario)

describe Gauge::Executor do
  subject { Gauge::Executor }
  describe ".execute_hooks" do
    describe "when OR-ing tags" do
      let(:execution_info) {{ currentSpec: { tags:["tag1"], currentScenario:{tags:['tag2', 'tag3']}}}}
      it 'should execute hook with no tags' do
        hook = double('hook')
        expect(hook).to receive(:call).with(execution_info)
        hooks = [{block: hook, options: {tags: [], operator: 'OR'}}]
        Gauge::Executor.execute_hooks(hooks, execution_info, true)
      end
    end

    let(:execution_info) { double('execution_info') }
    it 'execute_hook with tags AND operator' do
      execution_info.stub_chain(:currentSpec, :tags).and_return(["tag1", "tag2"])
      execution_info.stub_chain(:currentScenario, :tags).and_return([])
      hook = Hook.new
      hooks = [{block: hook, options: {tags: %w(tag1 tag2), operator: 'AND'}}]
      info = Info.new(Tags.new(%w(tag1 tag2)), Tags.new([]))
      Gauge::Executor.execute_hooks(hooks, execution_info, true)
      expect(hook.called).to eq(true)
      expect(hook.info).to eq(execution_info)
    end

    it 'execute_hook with non-matching tags AND operator' do
      hook = Hook.new
      hooks = [{block: hook, options: {tags: %w(tag1 tag2), operator: 'AND'}}]
      info = Info.new(Tags.new(%w(tag1 tag3)), Tags.new([]))
      Gauge::Executor.execute_hooks(hooks, info, true)
      expect(hook.called).to eq(false)
      expect(hook.info).to eq(nil)
    end

    it 'execute hook with tags OR operator' do
      hook = Hook.new
      hooks = [{block: hook, options: {tags: ['tag1'], operator: 'OR'}}]
      info = Info.new(Tags.new(%w(tag1 tag2)), Tags.new([]))
      Gauge::Executor.execute_hooks(hooks, info, true)
      expect(hook.called).to eq(true)
      expect(hook.info).to eq(info)
    end

    it 'execute hook with non-matching tags OR operator' do
      hook = Hook.new
      hooks = [{block: hook, options: {tags: ['tag1'], operator: 'OR'}}]
      info = Info.new(Tags.new(%w(tag4 tag2)), Tags.new([]))
      Gauge::Executor.execute_hooks(hooks, info, true)
      expect(hook.called).to eq(false)
      expect(hook.info).to eq(nil)
    end

    it 'execute hook with_non-matching tags' do
      hook = Hook.new
      hooks = [{block: hook, options: {tags: %w(tag1 tag2), operator: 'AND'}}]
      info = Info.new(Tags.new(['tag1']), Tags.new([]))
      Gauge::Executor.execute_hooks(hooks, info, true)

      expect(hook.called).to eq(false)
      expect(hook.info).to eq(nil)
    end

    it 'execute hook with non-matching tags and should filter false' do
      hook = Hook.new
      hooks = [{block: hook, options: {tags: %w(tag1 tag2), operator: 'AND'}}]
      info = Info.new(Tags.new(['tag1']), Tags.new([]))
      Gauge::Executor.execute_hooks(hooks, info, false)

      expect(hook.called).to eq(true)
      expect(hook.info).to eq(info)
    end
  end
end
