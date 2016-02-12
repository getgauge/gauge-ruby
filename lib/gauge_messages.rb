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

    def write(message)
      @messages.push(message)
    end

    def get
      @messages
    end

    def clear
      @messages = []
    end
  end
end
