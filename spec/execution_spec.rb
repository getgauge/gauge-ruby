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
  it 'execute hook without tags' do
    hook = Hook.new
    hooks = [{block: hook, options: {tags: [], operator: 'OR'}}]
    info = Info.new(Tags.new(['tag1']), Tags.new(%w(tag2 tag3)))
    Gauge::Executor.execute_hooks(hooks, info, true)
    expect(hook.called).to eq(true)
    expect(hook.info).to eq(info)
  end

  it 'execute_hook with tags AND operator' do
    hook = Hook.new
    hooks = [{block: hook, options: {tags: %w(tag1 tag2), operator: 'AND'}}]
    info = Info.new(Tags.new(%w(tag1 tag2)), Tags.new([]))
    Gauge::Executor.execute_hooks(hooks, info, true)
    expect(hook.called).to eq(true)
    expect(hook.info).to eq(info)
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



