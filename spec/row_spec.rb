=begin
 *  Copyright (c) ThoughtWorks, Inc.
 *  Licensed under the Apache License, Version 2.0
 *  See LICENSE.txt in the project root for license information.
=end
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
