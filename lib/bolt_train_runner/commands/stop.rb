require 'colorize'
require 'bolt_train_runner/commands/throttle'

module Commands
  def self.stop(_args, comms)
    unless comms
      puts 'Please connect first'.red
      return
    end
    Commands.throttle([0],comms)
  end
end