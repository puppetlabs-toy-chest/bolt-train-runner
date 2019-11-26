require 'bolt_train_runner/commands/throttle'
require 'bolt_train_runner/log'

module Commands
  def self.stop(_args, comms, log)
    unless comms
      log.error('Please connect first')
      return
    end
    Commands.throttle([0], comms, log)
  end
end