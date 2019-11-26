require 'bolt_train_runner/comms'
require 'bolt_train_runner/log'

module Commands
  def self.disconnect(comms, log)
    if comms.nil?
      log.error('Not currently connected')
      return
    end
    comms.disconnect
    log.info('Disconnected')
  end
end