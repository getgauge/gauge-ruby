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

describe Gauge::Processors do
  let(:given_block) { -> { puts 'foo' } }
  context '.get_step' do
    describe 'should return step block' do
      before { Gauge::MethodCache.add_step 'step_text', &given_block }
      it 'should get registered <block>' do
        expect(subject.get_step('step_text')).to eq given_block
      end
    end

    describe 'should throw exception when duplicate step impl' do
      before { Gauge::MethodCache.add_step 'step_text', &given_block }
      before { Gauge::MethodCache.add_step 'step_text', &given_block }
      it {
        expect { subject.get_step('step_text') }.to raise_error("Multiple step implementations found for => 'step_text'")
      }
    end
  end
end
