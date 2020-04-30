=begin
 *  Copyright (c) ThoughtWorks, Inc.
 *  Licensed under the Apache License, Version 2.0
 *  See LICENSE.txt in the project root for license information.
=end
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
  
