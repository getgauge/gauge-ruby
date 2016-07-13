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

describe Gauge::Row do
  let(:values) { ['Go Programming', '978-1453636671', 'John P. Baugh', '25.00']}
  let(:columns) { %w(Title ISBN Author Price)
  }

  context '[] accessed value' do
    subject { Gauge::Row.new(columns, values) }

    it ".['column_name'] fetches respective row value" do
      expect(subject['Title']).to eq 'Go Programming'
      expect(subject['ISBN']).to eq '978-1453636671'
      expect(subject['Author']).to eq 'John P. Baugh'
      expect(subject['Price']).to eq '25.00'
      expect(subject['sdf']).to eq nil
    end

    it '.[index] fetches respective row value' do
      expect(subject[0]).to eq 'Go Programming'
      expect(subject[1]).to eq '978-1453636671'
      expect(subject[2]).to eq 'John P. Baugh'
      expect(subject[3]).to eq '25.00'
    end
  end
end
