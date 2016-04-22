 
require 'rails/generators'
module Holaa
  module Generators
    class InstallGenerator < Rails::Generators::Base

      desc "Creates active_admin initializer, routes and copy locale
      files to your application."

     

     
      def build_and_setup_gem
          puts "Bulding requirements"
          source_root = File.expand_path("../", __FILE__)
          input = File.open("#{source_root}/templates/controllers/commands_controller.rb") {|f| f.read() }
          output = File.open("app/controllers/commands_controller.rb", 'w+') {|f| f.write(input) }
          File.open('Gemfile', 'a+') { |f|
            f << "\n gem 'ancestry' \n "  unless File.readlines("Gemfile").grep(/ancestry/).size > 0
            f << "\n gem 'acts_as_list' \n" unless File.readlines("Gemfile").grep(/acts_as_list/).size > 0
            f << 'gem "paranoia", "~> 2.0"' unless File.readlines("Gemfile").grep(/paranoia/).size > 0
          }
          system("bundle")
      end
    end
  end
end

