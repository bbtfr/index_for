require 'bundler/setup'

require 'minitest/autorun'

require 'active_model'
require 'action_controller'
require 'action_view'
require 'action_view/template'
require 'action_view/test_case'

$:.unshift File.expand_path("../../lib", __FILE__)
require 'index_for'

Dir["#{File.dirname(__FILE__)}/support/*.rb"].each { |f| require f }
I18n.enforce_available_locales = true
I18n.default_locale = :en

class ActionView::TestCase
  include IndexFor::Helper
end