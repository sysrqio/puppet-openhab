require 'spec_helper'
describe 'openhab' do

  context 'with defaults for all parameters' do
    it { should contain_class('openhab') }
  end
end
