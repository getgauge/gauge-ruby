=begin
 *  Copyright (c) ThoughtWorks, Inc.
 *  Licensed under the Apache License, Version 2.0
 *  See LICENSE.txt in the project root for license information.
=end
describe Gauge::Processors do
  block = <<-EOS
        step 'say <what> to <who>' do |what, who|
          puts 'hello'
        end
  EOS
  context '.get_step' do
    describe 'should return step block' do
      before {Gauge::MethodCache.add_step 'step_text', {block: block}}
      it 'should get registered <block>' do
        expect(subject.get_step('step_text')[:block]).to eq block
      end
    end

    describe 'should throw exception when duplicate step impl' do
      before {Gauge::MethodCache.add_step 'step_text', {block: block}}
      before {Gauge::MethodCache.add_step 'step_text', {block: block}}
      it {
        expect {subject.get_step('step_text')}.to raise_error("Multiple step implementations found for => 'step_text'")
      }
    end
  end
end
