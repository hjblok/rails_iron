require "iron_worker_ng"

module RailsIron
  module Worker
    def self.included(base)
      base.extend(ClassMethods)
    end

    module ClassMethods
      def iron_worker
        IronWorkerNG::Client.new
      end

      def perform_async(*args)
        queue({params: args})
      end

      def queue(payload = nil)
        begin
          iron_worker.tasks.create(self.name, payload)
        rescue Net::HTTP::Persistent::Error => t
          raise RailsIron::TemporaryError, t.message
        end
      end
    end

    # InstanceMethods
    attr_reader :params
    attr_accessor :iron_task_id

    def run
      begin
        perform(*params)
      rescue RailsIron::TemporaryError
        puts "TemporaryError raised, will retry task after 300 seconds"
        rerun
      end
    end

    def params=(params)
      raise RailsIron::PermanentError, "Expected #{params} to be an Array" unless params.is_a?(Array)
      @params = params
    end

    def rerun
      self.class.iron_worker.tasks.retry(iron_task_id, delay: 300)
    end
  end
end
