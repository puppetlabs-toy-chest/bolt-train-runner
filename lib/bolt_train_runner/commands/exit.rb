require 'bolt_train_runner/comms'
require 'bolt_train_runner/log'

module Commands
  def self.exit_program(comms, session_runner, log)
    session_runner.stop if session_runner
    comms.disconnect if comms
    log.info('Seeya later!')
    log.close
    exit 0
  end
end