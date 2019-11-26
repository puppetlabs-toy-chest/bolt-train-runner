require 'bolt_train_runner/comms'
require 'bolt_train_runner/log'

module Commands
  def self.throttle(args, comms, log)
    unless comms
      log.error('Please connect first')
      return
    end
    if args.empty? || args[0] =~ /help/i
      log.help('Command: throttle')
      log.help('Syntax: throttle <0-10> [forward|reverse]')
      log.help('Sets the throttle to the given level, between 0 and 10. May optionally provide a direction.')
      log.help('Note that power must be on first for this to take effect.')
      return
    end

    if args.is_a?(Hash)
      speed = args['speed']
      direction = args['direction']
    else
      speed, direction = args
    end
    
    speed = speed.to_i
    if speed < 0 or speed > 10
      log.error('Please select a speed between 0 and 10')
      return
    end

    unless direction.nil? || ['forward','reverse'].include?(direction)
      log.error('Direction must be either "forward" or "reverse"')
      return
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
    log.info("Throttle set to #{speed}#{direction_string}")
  end
end