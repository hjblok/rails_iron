require "pathname"

module RailsIron
  module Loader
    def self.included(base)
      base.load_rails
    end

    def load_rails
      unless defined?(Rails)
        if File.exists?("/task/config/environment.rb")
          ENV['RAILS_ENV'] ||= "production"
          require "/task/config/environment"
        end
      end
    end
  end
end

Module.send(:include, RailsIron::Loader)
