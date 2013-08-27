require "spec_helper"

class TestWork
  include RailsIron::Worker

  def perform
    true
  end
end


describe RailsIron::Worker do
  let(:instance) { TestWork.new }
  subject { instance }


  # InstanceMethods
  it { should respond_to :run }

  it "#perform the task" do
    instance.run.should be_true
  end

  context "ClassMethods" do
    subject { TestWork }

    it { should respond_to :perform_async }
  end

  context "RailsIron::TemporaryError" do
    before(:each) do
      instance.instance_eval do
        def perform; raise RailsIron::TemporaryError; end
      end
    end

    it { expect { instance.run }.not_to raise_error() }
  end
end
