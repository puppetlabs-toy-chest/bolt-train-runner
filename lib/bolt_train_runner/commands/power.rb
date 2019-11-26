require 'bolt_train_runner/comms'
require 'bolt_train_runner/log'

module Commands
  def self.power(args, comms, log)
    unless comms
      log.error('Please connect first')
      return
    end
    if args.empty? || args[0] =~ /help/i
      log.help('Command: power')
      log.help('Syntax: power <on|off>')
      log.help('Turns power to the train on or off. Must first be connected.')
      return
    end

    if args.is_a?(Hash)
      state = args['state']
    else
      state = args[0]
    end
    
    unless ['on','off'].include?(state)
      log.error('Please provide either "on" or "off"')
      return
    end

    vals = {'on' => '2', 'off' => '4'}
    value = vals[state]
    message = {
      'type'   => 'power',
      'method' => 'put',
      'data'   => {
        'name'  => 'LocoNet',
        'state' => value
      }
    }
    comms.send_message(message)
    log.info("Power #{state}")
  end
end
