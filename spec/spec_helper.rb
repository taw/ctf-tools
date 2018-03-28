require_relative "../lib/string"
require_relative "../lib/integer"

RSpec.configure do |config|
  config.define_derived_metadata do |meta|
    meta[:aggregate_failures] = true
  end
end
