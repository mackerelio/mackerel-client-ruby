$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'mackerel'

RSpec.configure do |config|
  config.disable_monkey_patching!
  config.filter_run_when_matching :focus

  config.order = :random
  Kernel.srand config.seed
end
