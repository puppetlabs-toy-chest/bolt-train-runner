require 'bolt_train_runner/comms'
require 'colorize'

module Commands
  def self.throttle(args, comms)
    unless comms
      puts 'Please connect first'.red
      return
    end
    if args.empty? || args[0] =~ /help/i
      puts 'Command: throttle'.cyan
      puts 'Syntax: throttle <0-10> [forward|reverse]'.cyan
      puts 'Sets the throttle to the given level, between 0 and 10. May optionally provide a direction.'.cyan
      puts 'Note that power must be on first for this to take effect.'.cyan
      return
    end

    speed = args[0].to_i
    if speed < 0 or speed > 10
      puts 'Please select a speed between 0 and 10'.red
      return
    end
    direction = nil
    if args.length > 1
      direction = args[1]
      unless ['forward','reverse'].include?(direction)
        puts 'Direction must be either "forward" or "reverse"'.red
        return
      end
    end

    message = {
      'type'   => 'throttle',
      'method' => 'post',
      'data'   => {
        'throttle' => 'bolttrain',
        'address'  => '6871',
        'speed'    => "#{speed/10.0}",
      }
    }
    message['data']['forward'] = direction == 'forward' if direction
    comms.send_message(message)
    direction_string = direction.nil? ? '' : " with direction #{direction}"
    puts "Throttle set to #{speed}#{direction_string}".green
  end
end