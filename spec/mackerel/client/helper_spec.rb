require 'mackerel/client/helper'

RSpec.describe Mackerel::Client::Helper do
  describe '.as_safe_metric_name' do
    it 'translates characters that cannot be used as a metric name to safe characters' do
      name = 'readme.md'
      expect(Mackerel::Client::Helper.as_safe_metric_name(name)).to eq('readme-md')
    end
  end
end
