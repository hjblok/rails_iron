require "spec_helper"

$iron_task_id = "123abc456def789ghi012jkl"

class TestWork
  include RailsIron::Worker

  def perform(a,b,c)
    true
  end
end


describe RailsIron::Worker do
  let(:instance) { TestWork.new }
  let(:params) { [1, "twee", "drie"] }
  subject { instance }

  before { instance.params = params }

  its(:iron_task_id) { should eq "123abc456def789ghi012jkl" }
  its(:params) { should eq params }

  # InstanceMethods
  it { should respond_to :run }
  it "#perform the task" do
    instance.should_receive(:perform).with(*params)
    instance.run
  end

  it { should respond_to :rerun }
  it "#rerun reruns the task" do
    stub_request(:post, "https://worker-aws-us-east-1.iron.io/2/projects/521cc0534c209d0005000005/tasks/123abc456def789ghi012jkl/retry").
      to_return(status: 200, body: fixture("post_tasks.json"))
    expect { instance.rerun }.not_to raise_error
  end

  it "#params= should set params" do
    expect { instance.params = ["twee"] }.to change { instance.params }.to(["twee"])
  end
  it "#params= should raise error when params isn't an Array" do
    expect { instance.params = "geen array" }.to raise_error(RailsIron::PermanentError)
  end

  context "ClassMethods" do
    subject { TestWork }

    before(:each) do
      stub_request(:post, "https://worker-aws-us-east-1.iron.io/2/projects/521cc0534c209d0005000005/tasks").
        to_return(status: 200, body: fixture("post_tasks.json"))
    end

    its(:iron_worker) { should be_kind_of(IronWorkerNG::Client) }

    it { should respond_to :perform_async }
    it { should respond_to :queue }

    it "#perform_async queues task" do
      subject.should_receive(:queue).with({params: []})
      subject.perform_async
    end
    it "#perform_async queues task with supplied args" do
      subject.should_receive(:queue).with({params: ["een", :twee, 3]})
      subject.perform_async("een", :twee, 3)
    end
  
    it "#queue queues task" do
      expect { subject.queue }.not_to raise_error
    end
    it "#queue optionally takes payload" do
      expect { subject.queue("payload") }.not_to raise_error
    end
  end

  context "#perform can raise RailsIron::TemporaryError to rerun the task" do
    before(:each) do
      instance.instance_eval do
        def perform(a,b,c); raise RailsIron::TemporaryError; end
      end
    end

    it "reruns task" do
      instance.should_receive(:rerun)
      instance.run
    end
  end

  context "#queue temporary exceptions raise RailsIron::TemporaryError" do
    it "#queue catches Rest::Wrappers::TyphoeusTimeoutError" do
      stub_request(:post, "https://worker-aws-us-east-1.iron.io/2/projects/521cc0534c209d0005000005/tasks").
        to_timeout
      expect { TestWork.queue }.to raise_error(RailsIron::TemporaryError, "HTTP Request Timed out. Curl code: operation_timedout. Curl error msg: Timeout was reached.")
    end
  end
end
