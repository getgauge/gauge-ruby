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
    context 'capture screenshot' do
        it 'should not have screenshot' do 
            expect(Gauge::GaugeScreenshot.instance.get.length).to eq 0
        end
        it 'should have screenshot' do
            Gauge.capture()
            expect(Gauge::GaugeScreenshot.instance.get.length).to eq 1
        end
    end
    context 'clear screenshot' do
        it 'should remove screenshot' do
            Gauge.capture()
            expect(Gauge::GaugeScreenshot.instance.get.length).to eq 2
            Gauge::GaugeScreenshot.instance.clear
            expect(Gauge::GaugeScreenshot.instance.get.length).to eq 0
        end
    end
end
  