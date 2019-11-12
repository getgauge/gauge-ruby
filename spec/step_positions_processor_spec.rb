# Copyright 2018 ThoughtWorks, Inc.

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
