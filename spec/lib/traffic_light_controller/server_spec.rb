require 'spec_helper'

describe TrafficLightController::Server do
  let(:board) { mock }
  let(:config) { mock }
  let(:server) { mock(accept: client) }
  let(:client) { mock }

  before do
    config.stub_chain(:server, :address).and_return("127.0.0.1")
    config.stub_chain(:server, :port).and_return(10000 + rand(1000))
    config.stub_chain(:arduino, :port).and_return("port")

    TrafficLightController::Config.stub(:new).and_return(config)
    TCPServer.stub(:new).and_return(server)
    STDOUT.stub(:puts)
  end

  context "public methods" do
    before do
      subject.stub(:board).and_return(board)
    end

    describe "#initialize" do
      it "should call address_in_use_error if address is in use" do
        TCPServer.should_receive(:new).and_raise(Errno::EADDRINUSE)
        described_class.any_instance.should_receive(:address_in_use_error)
        described_class.new
      end

      it "should call address_in_use_error if address is not available" do
        TCPServer.should_receive(:new).and_raise(Errno::EADDRNOTAVAIL)
        described_class.any_instance.should_receive(:address_not_available_error)
        described_class.new
      end
    end

    describe "#change_pins" do
      before { subject.stub(:init_board) }

      it "set high the pin pointed to by path" do
        config.stub_chain(:arduino, :lights).and_return({"blah" => 4})
        board.should_receive(:turnOff)
        board.should_receive(:setHigh).with(4)
        board.should_receive(:close)

        subject.send(:change_pins, "blah")
      end

      it "should not set high any pins" do
        board.should_receive(:turnOff)
        board.should_not_receive(:setHigh)
        board.should_receive(:close)

        subject.send(:change_pins, "off")
      end
    end
  end

  context "private methods" do
    describe "#board" do
      it "should instantiate a new arduino object" do
        subject.send(:init_board)
      end
    end
  end

  describe "#start_thread_and_do_work" do
    it "should start a thread" do
      Thread.should_receive(:start).and_yield(client)
      subject.should_receive(:accept_request).with(client)
      subject.send(:start_thread_and_do_work)
    end
  end

  describe "#accept_request" do
    it "should call process path" do
      subject.should_receive(:process_request).with(client).and_return(:processed)
      client.should_receive(:close)

      subject.send(:accept_request, client)
    end

    it "should rescue from all exceptions and log them to STDERR" do
      subject.should_receive(:process_request).and_raise RuntimeError
      STDERR.should_receive(:puts)
      client.should_receive(:close)

      subject.send(:accept_request, client)
    end
  end
end
