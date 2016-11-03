require 'spec_helper'
describe 'l2mesh' do

  context 'with defaults for all parameters' do
    it { should contain_class('l2mesh') }
  end
end
