=begin
 *  Copyright (c) ThoughtWorks, Inc.
 *  Licensed under the Apache License, Version 2.0
 *  See LICENSE.txt in the project root for license information.
=end
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
