module IndexFor
  module Generators
    class InstallGenerator < Rails::Generators::Base
      desc "Copy IndexFor installation files"
      class_option :template_engine, :desc => 'Template engine to be invoked (erb or haml or slim).'
      source_root File.expand_path('../templates', __FILE__)

      def copy_initializers
        copy_file 'index_for.rb', 'config/initializers/index_for.rb'
      end

      def copy_locale_file
        copy_file 'en.yml', 'config/locales/index_for.en.yml'
      end

      def copy_generator_template
        engine = options[:template_engine]
        copy_file "index.html.#{engine}", "lib/templates/#{engine}/scaffold/index.html.#{engine}"
      end
    end
  end
end
