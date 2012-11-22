$:.push File.expand_path("../lib", __FILE__)
require "traffic_light_controller/version"

Gem::Specification.new do |s|
  s.name = "traffic_light_controller"
  s.version = TrafficLightController::VERSION
  s.platform = Gem::Platform::RUBY
  s.author = "Juan C. Muller"
  s.email  = "jcmuller@gmail.com"
  s.homepage = "http://github.com/jcmuller/traffic_light_controller"
  s.license = "GPL"

  s.summary = <<-EOS
  EOS
  s.description = ""

  s.files        = `git ls-files`.split($\) - %w(.rspec)
  s.require_path = "lib"
  s.bindir       = "bin"
  s.executables  = %w(traffic_light_controller)

  s.homepage   = "http://github.com/jcmuller/traffic_light_controller"
  s.test_files = Dir["spec/**/*_spec.rb"]

  s.add_development_dependency("guard")
  s.add_development_dependency("guard-bundler")
  s.add_development_dependency("guard-ctags-bundler")
  s.add_development_dependency("guard-rspec")
  s.add_development_dependency("pry")
  s.add_development_dependency("pry-debugger")
  s.add_development_dependency("pry-stack_explorer")
  s.add_development_dependency("rake")
  s.add_development_dependency("terminal-notifier-guard")

  s.add_dependency("sinatra")
  s.add_dependency("arduino")
  s.add_dependency("json")
  s.add_dependency("hashie")
  s.add_dependency("command_line_helper")
end
