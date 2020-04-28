=begin
 *  Copyright (c) ThoughtWorks, Inc.
 *  Licensed under the Apache License, Version 2.0
 *  See LICENSE.txt in the project root for license information.
=end
describe Gauge::Table do
  let(:proto_table) { double('proto_table') }
  let(:row1) { double('row1')}
  let(:row2) { double('row2')}
  let(:columns) { %w(Title ISBN Author Price) }
  let(:table_str) {
    '|Title         |ISBN          |Author       |Price|\n'\
    '|--------------|--------------|-------------|-----|\n'\
    '|Go Programming|978-1453636671|John P. Baugh|25.00|\n'\
    '|The Way to Go |978-1469769165|Ivo Balbaert |20.00|'
  }

  before {
    allow(proto_table).to receive_message_chain(:headers, :cells) { columns }
    allow(row1).to receive_message_chain(:cells) { ['Go Programming', '978-1453636671', 'John P. Baugh', '25.00']}
    allow(row2).to receive_message_chain(:cells) { ['The Way to Go', '978-1469769165', 'Ivo Balbaert', '20.00']}
    allow(proto_table).to receive_message_chain(:rows) {[row1, row2]}
  }

  describe ".to_s" do
      subject { Gauge::Table.new(proto_table).to_s }
      it { is_expected.to eq table_str }
  end

  context '[] accessed value' do
    context 'with integer key' do
      subject { Gauge::Table.new(proto_table)[0] }

      it { is_expected.to_not be_nil }
      it { is_expected.to be_a Gauge::Row }

      it ".['column_name'] fetches respective row value" do
        expect(subject['Title']).to eq 'Go Programming'
        expect(subject['ISBN']).to eq '978-1453636671'
        expect(subject['Author']).to eq 'John P. Baugh'
        expect(subject['Price']).to eq '25.00'
      end

      context 'and index is out of range' do
        subject { Gauge::Table.new(proto_table)[4] }
        it { is_expected.to be_nil }
      end
    end

    context 'with string key' do
      subject { Gauge::Table.new(proto_table)['Title'] }

      it { is_expected.to_not be_nil }
      it { is_expected.to be_a Array }
      it 'should contain corresponding row values' do
        is_expected.to match_array ['Go Programming', 'The Way to Go']
      end

      context 'when no such column name' do
        subject { Gauge::Table.new(proto_table)['RandomString'] }
        it { is_expected.to be_nil }
      end
    end
  end
end
