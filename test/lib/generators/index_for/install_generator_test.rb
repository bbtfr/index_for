require 'test_helper'

require 'rails/generators/test_case'
require 'generators/index_for/install_generator'

class IndexForGeneratorTest < Rails::Generators::TestCase
  tests IndexFor::Generators::InstallGenerator
  destination File.expand_path('../../tmp', __FILE__)
  setup :prepare_destination
  teardown { rm_rf(destination_root) }

  test 'generates example locale file' do
    run_generator
    assert_file 'config/locales/index_for.en.yml'
  end

  test 'generates the index_for initializer' do
    run_generator
    assert_file 'config/initializers/index_for.rb',
      /config.index_for_tag = :div/
  end

  %W(erb haml slim).each do |engine|
    test "generates the scaffold template when using #{engine}" do
      run_generator ['-e', engine]
      assert_file "lib/templates/#{engine}/scaffold/index.html.#{engine}"
    end
  end
end
