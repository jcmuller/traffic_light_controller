require "rubygems"
require "bundler/setup"
require "arduino"
require "hashie"
require "socket"
require "yaml"

module TrafficLightController
  autoload :Config, "traffic_light_controller/config"
  autoload :CLI, "traffic_light_controller/cli"
  autoload :Server, "traffic_light_controller/server"
  autoload :VERION, "traffic_light_controller/version"
end
