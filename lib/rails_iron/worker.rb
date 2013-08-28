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
        queue(args)
      end

      def queue(payload = nil)
        iron_worker.tasks.create(self.name, payload)
      end
    end

    # InstanceMethods
    def run
      begin
        perform
      rescue RailsIron::TemporaryError
        puts "TemporaryError raised, will retry task after 300 seconds"
        rerun
      end
    end

    def args
      args = JSON.load(params)
      raise RailsIron::PermanentError, "Expected #{params} to be an Array" unless args.is_a?(Array)
      args
    end

    def iron_task_id
      $iron_task_id
    end

    def params
      $params
    end

    def rerun
      self.class.iron_worker.tasks.retry(iron_task_id, delay: 300)
    end
  end
end
