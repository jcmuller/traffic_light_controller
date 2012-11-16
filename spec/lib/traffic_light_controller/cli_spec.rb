require 'spec_helper'

describe TrafficLightController::CLI do
  let(:config) { mock }
  let(:server) { mock }

  before do
    TrafficLightController::Config.stub(:new).and_return(config)
    TrafficLightController::Server.stub(:new).and_return(server)

    config.stub_chain(:server, :address).and_return("127.0.0.1")
    config.stub_chain(:server, :port).and_return(5678)
  end

  describe ".run" do
    it "should initialize server and call work on it" do
      server = mock
      TrafficLightController::Server.should_receive(:new).and_return(server)
      server.should_receive(:work)
      described_class.run
    end
  end

  describe "show_help_and_exit" do
    it "should show help" do
      STDOUT.stub(:puts)
      subject.should_receive(:help_info)
      expect{ subject.send(:show_help_and_exit) }.to raise_error SystemExit
    end
  end
end
