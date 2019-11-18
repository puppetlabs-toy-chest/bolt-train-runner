require 'bolt_train_runner/comms'
require 'colorize'

module Commands
  def self.power(args, comms)
    unless comms
      puts 'Please connect first'.red
      return
    end
    if args.empty? || args[0] =~ /help/i
      puts 'Command: power'.cyan
      puts 'Syntax: power <on|off>'.cyan
      puts 'Turns power to the train on or off. Must first be connected.'.cyan
      return
    end

    if args.is_a?(Hash)
      state = args['state']
    else
      state = args[0]
    end
    
    unless ['on','off'].include?(state)
      puts 'Please provide either "on" or "off"'.red
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
    puts "Power #{state}".green
  end
end
