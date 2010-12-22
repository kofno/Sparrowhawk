require 'sparrowhawk'
require 'aruba/api'

require 'support/matchers'

RSpec.configure do |config|
  config.color_enabled = true
  config.include Aruba::Api
end
