require "hashie"
require "yaml"

module TrafficLightController
  class Config
    def initialize
      @config = Hashie::Mash.new(YAML.load_file("#{ENV["HOME"]}/.config/traffic_light_controller/config.yml"))
    end

    def method_missing(method_name, *args, &block)
      return config[method_name.to_s] if config.has_key?(method_name.to_s)
      super
    end

    def respond_to?(method_name)
      config.has_key?(method_name.to_s) || super
    end

    private

    attr_reader :config
  end
end
