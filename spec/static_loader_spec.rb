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
    subject {Gauge::MethodCache}
    before(:each) {
      subject.clear
    }

    it 'should populate method cache' do
      file = 'foo.rb'
      content = "step 'foo <vowels>' do |v|\nend"
      ast = Gauge::CodeParser.code_to_ast content
      Gauge::StaticLoader.load_steps(file, ast)

      expect(subject.valid_step? 'foo {}').to eq true
      expect(subject.get_step_text 'foo {}').to eq 'foo <vowels>'
    end

    it 'should load aliases in method cache' do
      file = 'foo.rb'
      content = "step 'foo <vowels>','bar <vowels>' do |v|\nend"
      ast = Gauge::CodeParser.code_to_ast content
      Gauge::StaticLoader.load_steps(file, ast)

      expect(subject.valid_step? 'foo {}').to eq true
      expect(subject.get_step_text 'foo {}').to eq 'foo <vowels>'
      expect(subject.valid_step? 'bar {}').to eq true
      expect(subject.get_step_text 'bar {}').to eq 'bar <vowels>'
    end

    it 'should load recoverable steps' do
      file = 'foo.rb'
      content = "step 'foo <bar>', :continue_on_failure => true  do |v|\nend"
      ast = Gauge::CodeParser.code_to_ast content
      Gauge::StaticLoader.load_steps(file, ast)

      expect(subject.valid_step? 'foo {}').to eq true
      expect(subject.recoverable? 'foo {}').to eq true
    end

    it 'should load recoverable aliases steps' do
      file = 'foo.rb'
      content = "step 'foo <vowels>','bar <vowels>','hey <vowels>', :continue_on_failure => true do |v|\nend"
      ast = Gauge::CodeParser.code_to_ast content
      Gauge::StaticLoader.load_steps(file, ast)

      {'foo {}' => 'foo <vowels>', 'bar {}' => 'bar <vowels>', 'hey {}' => 'hey <vowels>'}.each {|k,v|
        expect(subject.valid_step? k).to eq true
        expect(subject.recoverable? k).to eq true
        expect(subject.has_alias? v).to eq true
      }
    end

    it 'should not load empty steps' do
      file = 'foo.rb'
      content = "step '' do |v|\nend"
      ast = Gauge::CodeParser.code_to_ast content
      Gauge::StaticLoader.load_steps(file, ast)

      expect(subject.valid_step? 'foo {}').to eq false
    end

    it 'reload a given file' do
      file = '/temp/foo.rb'
      ast = Gauge::CodeParser.code_to_ast "step 'foo <vowels>' do |v|\nend"
      Gauge::StaticLoader.load_steps(file, ast)
      ast = Gauge::CodeParser.code_to_ast "step 'hello <vowels>' do |v|\nend"
      Gauge::StaticLoader.reload_steps(file, ast)
      expect(subject.valid_step? 'foo {}').to eq false
      expect(subject.valid_step? 'hello {}').to eq true
    end
  end
end
