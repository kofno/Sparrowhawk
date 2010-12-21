require 'sparrowhawk'
require 'aruba/api'

RSpec.configure do |config|
  config.color_enabled = true
  config.include Aruba::Api
end
