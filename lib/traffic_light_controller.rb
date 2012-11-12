require "rubygems"
require "arduino"
require "getoptlong"
require "hashie"
require "socket"
require "yaml"

module TrafficLightController
  autoload :Config, "traffic_light_controller/config"
  autoload :CLI, "traffic_light_controller/cli"
  autoload :Server, "traffic_light_controller/server"
  autoload :VERSION, "traffic_light_controller/version"
end
