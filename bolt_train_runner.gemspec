
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "bolt_train_runner/version"

Gem::Specification.new do |spec|
  spec.name          = "bolt_train_runner"
  spec.version       = BoltTrainRunner::VERSION
  spec.authors       = ["Nick Burgan"]
  spec.email         = ["nickb@puppet.com"]

  spec.summary       = "CLI/Service for talking to the Bolt Train JMRI JSON Server"
  spec.description   = "This is a command line tool for talking to the Bolt Train JMRI JSON Server. It includes a method for installing it as a service, working in concert with the Bolt Train API server."
  spec.homepage      = "https://github.com/puppetlabs/bolt-train-runner"
  spec.license       = "MIT"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  #spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
  #  `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  #end
  spec.files         = Dir['LICENSE.txt', 'README.md', 'lib/**/*']
  spec.bindir        = "bin"
  spec.executables   = ['bolt_train']
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 2"
  spec.add_development_dependency "rake", "~> 10.0"

  spec.add_dependency 'websocket'
  spec.add_dependency 'event_emitter'
  spec.add_dependency 'colorize'
end
