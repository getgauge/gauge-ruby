=begin
 *  Copyright (c) ThoughtWorks, Inc.
 *  Licensed under the Apache License, Version 2.0
 *  See LICENSE.txt in the project root for license information.
=end
describe Gauge::Util do
  context '.get_param_name' do
    it 'should give a arg name which is not used alread' do
      expect(Gauge::Util.get_param_name(["arg"], 0)).to eq 'arg_0'
      expect(Gauge::Util.get_param_name(["arg_0"], 0)).to eq 'arg_1'
      expect(Gauge::Util.get_param_name(["arg_1"], 1)).to eq 'arg_2'
    end
  end
end
