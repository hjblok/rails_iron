require "spec_helper"

$iron_task_id = "123abc456def789ghi012jkl"

class TestWork
  include RailsIron::Worker

  def perform
    true
  end
end


describe RailsIron::Worker do
  let(:instance) { TestWork.new }
  subject { instance }

  its(:iron_task_id) { should eq "123abc456def789ghi012jkl" }

  # InstanceMethods
  it { should respond_to :run }
  it "#perform the task" do
    instance.run.should be_true
  end

  it { should respond_to :rerun }
  it "#rerun reruns the task" do
    stub_request(:post, "https://worker-aws-us-east-1.iron.io/2/projects/521cc0534c209d0005000005/tasks/123abc456def789ghi012jkl/retry").
      to_return(status: 200, body: fixture("post_tasks.json"))
    expect { subject.rerun }.not_to raise_error
  end

  context "ClassMethods" do
    subject { TestWork }

    its(:iron_worker) { should be_kind_of(IronWorkerNG::Client) }

    it { should respond_to :perform_async }
    it { should respond_to :queue }
  
    it "#queue queues task" do
      stub_request(:post, "https://worker-aws-us-east-1.iron.io/2/projects/521cc0534c209d0005000005/tasks").
        to_return(status: 200, body: fixture("post_tasks.json"))
      expect { subject.queue }.not_to raise_error
    end
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
