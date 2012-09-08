require 'spec_helper'

describe TrafficLightController::Config do
  describe "#initialize" do
    before do
      YAML.should_receive(:load_file).and_return({ foo: { bar: "fight" } })
    end

    it "should instantiate a mash for all the properties in YAML file" do
      subject.foo.should == Hashie::Mash.new({ bar: "fight" })
      subject.foo.bar.should == "fight"
      subject.foo[:bar].should == "fight"
      subject.foo["bar"].should == "fight"
    end
  end
end
