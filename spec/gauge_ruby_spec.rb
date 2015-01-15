require 'rspec'
require_relative '../lib/gauge_ruby.rb'

describe "gauge_ruby" do
	foo_block=->{puts "foo"}
	describe "execution hooks" do
		describe $before_step_hooks do
			before_step &foo_block
			
			it { should include(foo_block)}
		end

		describe $before_spec_hooks do
			before_spec &foo_block
			
			it { should include(foo_block)}
		end

		describe $before_scenario_hooks do
			before_scenario &foo_block
			
			it { should include(foo_block)}
		end

		describe $before_suite_hooks do
			before_suite &foo_block
			
			it { should include(foo_block)}
		end

		describe $after_step_hooks do
			after_step &foo_block
			
			it { should include(foo_block)}
		end

		describe $after_spec_hooks do
			after_spec &foo_block
			
			it { should include(foo_block)}
		end

		describe $after_scenario_hooks do
			after_scenario &foo_block
			
			it { should include(foo_block)}
		end

		describe $after_suite_hooks do
			after_suite &foo_block
			
			it { should include(foo_block)}
		end
	end

	describe "step definitions" do
		before(:each) {
			["foo", "bar", "baz"].each{ |v|
				allow(Connector).to receive(:step_value).with(v).and_return(v)
			}
			step "foo", &foo_block 
		}

		describe $steps_map do
			it { should include("foo" => foo_block)}
		end

		describe $steps_text_map do
			it { should include "foo"=>"foo" }
		end

		describe $steps_with_aliases do
			before(:each) {	step "bar", "baz", &foo_block }

			it { should include "bar", "baz" }
		end
	end
end