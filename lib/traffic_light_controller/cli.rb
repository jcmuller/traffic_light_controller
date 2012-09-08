module TrafficLightController
  class CLI
    def initialize
      TrafficLightController::Server.new.work
    end
  end
end
