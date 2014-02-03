class TestWork
  include RailsIron::Worker

  def perform(a,b,c)
    true
  end
end
