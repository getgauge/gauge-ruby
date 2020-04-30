=begin
 *  Copyright (c) ThoughtWorks, Inc.
 *  Licensed under the Apache License, Version 2.0
 *  See LICENSE.txt in the project root for license information.
=end
describe Gauge::Processors do
  let(:step_positions_request) {double('request')}
  before(:each) {
    Gauge::MethodCache.clear
  }
  context '.process_step_positions_request' do
    describe 'should return step positions for a given file' do
      before {
        content = "step 'foo' do\n\tputs 'hello'\nend\n"
        ast = Gauge::CodeParser.code_to_ast content
        Gauge::StaticLoader.load_steps 'foo.rb', ast
        allow(step_positions_request).to receive(:filePath).and_return('foo.rb')
      }
      it 'should give step positions' do
        positions = subject.process_step_positions_request(step_positions_request).stepPositions
        expect(positions[0].stepValue).to eq 'foo'
        expect(positions[0].span.start).to eq 1
        expect(positions[0].span.end).to eq 3
      end
    end

    describe 'should return empty step positions for a given file' do
      before {
        content = "step 'foo' do\n\tputs 'hello'\nend\n"
        ast = Gauge::CodeParser.code_to_ast content
        Gauge::StaticLoader.load_steps 'foo.rb', ast
        allow(step_positions_request).to receive(:filePath).and_return('bar.rb')
      }
      it 'should give empty for not loaded file' do
        positions = subject.process_step_positions_request(step_positions_request).stepPositions
        expect(positions.empty?).to eq true
      end
    end
  end
end
