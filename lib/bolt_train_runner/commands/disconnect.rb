require 'bolt_train_runner/comms'
require 'colorize'

module Commands
  def self.disconnect(comms)
    if comms.nil?
      puts 'Not currently connected'.red
      return
    end
    comms.disconnect
    puts 'Disconnected'.green
  end
end