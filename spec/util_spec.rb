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
  context '.remove_special_chars' do
    it 'should remove all special characters' do
      expect(Gauge::Util.remove_special_chars 'hell#o').to eq 'hello'
      expect(Gauge::Util.remove_special_chars '567').to eq '567'
      expect(Gauge::Util.remove_special_chars '56abcd').to eq '56abcd'
      expect(Gauge::Util.remove_special_chars '56a|{}[]\!-+ =bcd<>?/,.&^%$#@*()').to eq '56abcd'
      expect(Gauge::Util.remove_special_chars 'hello_world1').to eq 'hello_world1'
      expect(Gauge::Util.remove_special_chars 'a').to eq 'a'
    end
  end
end
