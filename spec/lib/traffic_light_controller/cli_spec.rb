require 'spec_helper'

describe TrafficLightController::CLI do
  describe "#work" do
    it "should initialize server and call work on it" do
      server = mock
      TrafficLightController::Server.should_receive(:new).and_return(server)
      server.should_receive(:work)
      described_class.new
    end
  end
end
