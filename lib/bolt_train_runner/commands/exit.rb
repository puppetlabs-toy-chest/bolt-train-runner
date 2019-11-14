require 'colorize'
require 'bolt_train_runner/comms'

module Commands
  def self.exit_program(comms)
    if comms
      comms.disconnect
    end
    puts 'Seeya later!'.green
    exit 0
  end
end