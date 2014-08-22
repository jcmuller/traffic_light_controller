require 'spec_helper'

describe TrafficLightController::Config do
  describe "#initialize" do
    before do
      expect(YAML).to receive(:load_file).and_return({ foo: { bar: "fight" } })
    end

    its(:foo) { should eq Hashie::Mash.new({ bar: "fight" }) }
    its("foo.bar") { should eq "fight" }
    it { expect(subject.foo[:bar]).to eq "fight" }
    it { expect(subject.foo["bar"]).to eq "fight" }
  end
end
