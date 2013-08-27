module RailsIron
  module Worker
    def self.included(base)
      base.extend(ClassMethods)
    end

    module ClassMethods
      def perform
        puts "dong the ahrd wrko"
        # begin
          self.new.perform
        # rescue
        # end
      end

      def perform_async
        puts "perform_async"
      end
      # def perform_async(*args)
        # client_push('class' => self, 'args' => args)
      # end
    end

    # InstanceMethods
    def run
      perform
    end
  end
end
