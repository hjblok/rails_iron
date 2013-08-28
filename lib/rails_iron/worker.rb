require "iron_worker_ng"

module RailsIron
  module Worker
    def self.included(base)
      base.extend(ClassMethods)
    end

    module ClassMethods
      end

      def perform_async
        puts "perform_async"
      end
      # def perform_async(*args)
        # client_push('class' => self, 'args' => args)
      # end

      def schedule
        client = IronWorkerNG::Client.new
        client.schedules.create(self.name)
      end
    end

    # InstanceMethods
    def run
      begin
        perform
      rescue RailsIron::TemporaryError
      end
    end
  end
end
