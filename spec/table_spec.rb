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

describe Gauge::Table do
  let(:proto_table) { double('proto_table') }
  let(:row1) { double('row1')}
  let(:row2) { double('row2')}
  let(:columns) {["Title", "ISBN", "Author", "Price"]}
  before {
    allow(proto_table).to receive_message_chain(:headers, :cells) { columns }
    allow(row1).to receive_message_chain(:cells) { ["Go Programming", "978-1453636671", "John P. Baugh", "25.00"]}
    allow(row2).to receive_message_chain(:cells) { ["The Way to Go", "978-1469769165", "Ivo Balbaert", "20.00"]}
    allow(proto_table).to receive_message_chain(:rows) {[row1, row2]}
  }

  context "[] accessed value" do
    context "with integer key" do
      subject { Gauge::Table.new(proto_table)[0] }

      it { is_expected.to_not be_nil }
      it { is_expected.to be_a Hash }

      it "has column names as keys" do
        expect(subject.keys).to match_array columns
      end

      it ".['column_name'] fetches respective row value" do
        expect(subject['Title']).to eq "Go Programming"
        expect(subject['ISBN']).to eq "978-1453636671"
        expect(subject['Author']).to eq "John P. Baugh"
        expect(subject['Price']).to eq "25.00"
      end
    end

    context "with string key" do
      subject { Gauge::Table.new(proto_table)["Title"] }

      it { is_expected.to_not be_nil }
      it { is_expected.to be_a Array }
      it "should contain corresponding row values" do
        is_expected.to match_array ["Go Programming", "The Way to Go"]
      end

      context "when no such column name" do
        subject { Gauge::Table.new(proto_table)["RandomString"] }
        it { is_expected.to be_a Array }
        it { is_expected.to be_empty }
      end
    end
  end
end
