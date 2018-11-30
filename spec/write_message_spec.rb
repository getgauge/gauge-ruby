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

describe Gauge do
  context '.write_message' do
    let(:messages) { ['hello world', 'hello world1', 'hello world2'] }
    before { messages.each { |m| Gauge.write_message m } }

    it { expect(Gauge::GaugeMessages.instance.get).to match_array messages }
  end

  context '.pending_messages' do
    it 'should not contain nil messages' do
      Gauge::GaugeMessages.instance.clear
      ["message1",nil, "message2",nil].each { |m| Gauge.write_message m}

      expect(Gauge::GaugeMessages.instance.get).to match_array ['message1', 'message2']
    end
  end

  context '.clear_messages' do
    it 'should clear all gauge_messages' do
      Gauge.write_message 'custom1'
      Gauge::GaugeMessages.instance.clear
      Gauge.write_message 'custom'

      expect(Gauge::GaugeMessages.instance.get).to match_array ['custom']
    end
  end
end
