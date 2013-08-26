require "pathname"

module RailsIron
  module Loader
    def self.included(base)
      base.load_rails
    end

    def load_rails
      unless defined?(Rails)
        config = ::File.expand_path('../config/environment', $0)

        if File.exists?(config)
          ENV['RAILS_ENV'] ||= "production"
          require ::File.expand_path('../config/environment', config)
        end
      end
    end
  end
end

Module.send(:include, RailsIron::Loader)
