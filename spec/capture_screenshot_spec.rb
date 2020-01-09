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
    screenshot_dir = File.expand_path('./tmp_screenshots_dir')
    before(:all) {
        Dir.mkdir(screenshot_dir)
        ENV['gauge_screenshots_dir'] = screenshot_dir
    }

    after(:all) {
        FileUtils.rm_rf(screenshot_dir)
        ENV['gauge_screenshots_dir'] = nil
    }
    before(:each) {
        Gauge.configure { |c|  c.screengrabber = -> { return "screenshotdata" }}
      }
    context 'capture screenshot' do
        it "should have a screenshot" do
            file = File.join(screenshot_dir, 'screenshot-1.png')
            allow(Gauge::Util).to receive(:unique_screenshot_file).and_return(file)
            Gauge.capture
            expect(Gauge::GaugeScreenshot.instance.pending_screenshot).to match_array ["screenshot-1.png"]
            expect(File.read(file)).to eq("screenshotdata")
        end
    end
    context 'clear screenshot' do
        it "should clear screenshot after collecting them" do
            file = File.join(screenshot_dir, 'screenshot-2.png')
            allow(Gauge::Util).to receive(:unique_screenshot_file).and_return(file)
            Gauge.capture
            expect(Gauge::GaugeScreenshot.instance.pending_screenshot).to match_array ["screenshot-2.png"]
            expect(Gauge::GaugeScreenshot.instance.pending_screenshot).to match_array []
        end
    end

    context 'capture file based screenshot' do
        it "should have a screenshot" do
            Gauge.configure { |c|  c.custom_screenshot_writer = -> { return "screenshot-3.png" }}
            Gauge.capture
            expect(Gauge::GaugeScreenshot.instance.pending_screenshot).to match_array ["screenshot-3.png"]
        end
    end
end
  