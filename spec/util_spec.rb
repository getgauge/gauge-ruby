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

describe Gauge::Util do
  context '.get_param_name' do
    it 'should give a arg name which is not used alread' do
      expect(Gauge::Util.get_param_name(["arg"], 0)).to eq 'arg_0'
      expect(Gauge::Util.get_param_name(["arg_0"], 0)).to eq 'arg_1'
      expect(Gauge::Util.get_param_name(["arg_1"], 1)).to eq 'arg_2'
    end
  end
end
