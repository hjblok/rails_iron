# make iron_task_id global available
if respond_to?("iron_task_id")
  $iron_task_id = iron_task_id
end

require_relative "rails_iron/error"
require_relative "rails_iron/loader"
require_relative "rails_iron/worker"
