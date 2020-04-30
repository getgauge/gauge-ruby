=begin
 *  Copyright (c) ThoughtWorks, Inc.
 *  Licensed under the Apache License, Version 2.0
 *  See LICENSE.txt in the project root for license information.
=end
# @api public
module Gauge
  class << self
    # @api public
    # Custom Messages for Gauge
    # Lets you send custom execution messages to Gauge which are printed in reports.
    #
    # @example
    #   Gauge.write_message 'The answer is 42.'
    def write_message(message)
      GaugeMessages.instance.write(message)
    end
  end

  # @api private
  class GaugeMessages
    def initialize
      @messages = []
    end

    def self.instance
      @gauge_messages ||= GaugeMessages.new
    end

    def pending_messages()
        pending_messages = @messages.select { |m| m != nil}
        @messages = []
        pending_messages
    end

    def write(message)
      @messages.push(message)
    end

    def get
      @messages.select { |m| m != nil}
    end

    def clear
      @messages = []
    end
  end
end
