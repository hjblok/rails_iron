require "pathname"

module RailsIron
  module Loader
    def self.included(base)
      base.load_rails
      base.load_worker
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

    def load_worker
      klass_name = File.basename($0, ".rb").camel_case
      worker_klass = Object.const_set(klass_name, Class.new)
      worker_klass.class_eval do
        class << self
          def perform
            puts "doing some work"
            # begin
              self.new.perform
            # rescue
            # end
          end
        end
      end
    end
  end
end

Module.send(:include, RailsIron::Loader)
