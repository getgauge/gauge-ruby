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

describe Gauge::StaticLoader do

  context 'load method cache from file content without executing' do
    subject { Gauge::MethodCache }
    before(:each){
      subject.clear
    }

    it 'should pupuplate method cache' do
      file = 'foo.rb'
      content = "@vowels = nil
step 'foo <vowels>' do |v|
  @vowels = v
end"
      ast = Gauge::CodeParser.code_to_ast content
      Gauge::StaticLoader.load_steps(file, ast)
      expect(subject.valid_step? 'foo {}').to eq true
      expect(subject.get_step_text 'foo {}').to eq 'foo <vowels>'
    end

    it 'reload a given file' do
      file = 'foo.rb'
      content = "@vowels = nil
step 'foo <vowels>' do |v|
  @vowels = v
end"
      ast = Gauge::CodeParser.code_to_ast content
      Gauge::StaticLoader.load_steps(file, ast)
      expect(subject.valid_step? 'foo {}').to eq true
      expect(subject.get_step_text 'foo {}').to eq 'foo <vowels>'
      content = "@vowels = nil
step 'hello <vowels>' do |v|
  @vowels = v
end"
      ast = Gauge::CodeParser.code_to_ast content
      Gauge::StaticLoader.reload_steps(file, ast)
      expect(subject.valid_step? 'foo {}').to eq false
      expect(subject.valid_step? 'hello {}').to eq true
    end
  end
end
