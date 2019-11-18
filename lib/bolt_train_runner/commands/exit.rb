require 'colorize'
require 'bolt_train_runner/comms'

module Commands
  def self.exit_program(comms, session_runner)
    session_runner.stop if session_runner
    comms.disconnect if comms
    puts 'Seeya later!'.green
    exit 0
  end
end