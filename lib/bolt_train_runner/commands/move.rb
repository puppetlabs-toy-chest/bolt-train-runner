require 'bolt_train_runner/comms'
require 'bolt_train_runner/commands/throttle'
require 'bolt_train_runner/commands/stop'
require 'bolt_train_runner/log'

module Commands
  def self.move(args, comms, log)
    unless comms
      log.error('Please connect first')
      return
    end
    if args.empty? || args[0] =~ /help/i
      log.help('Command: move')
      log.help('Syntax: move <forward|reverse> <speed 0-10> <time 1-60>')
      log.help('Move the train the given direction at the given speed for the given number of seconds')
      log.help('Note that the power must be on first')
      return
    end


    if args.is_a?(Hash)
      direction = args['direction']
      speed = args['speed']
      time = args['time']
    else
      direction, speed, time = args
    end
  
    unless direction && speed && time
      log.error('Please provide direction, speed, and time')
      return
    end
    speed = speed.to_i
    time = time.to_i
    direction = direction == 'f' ? 'forward' : direction == 'r' ? 'reverse' : direction
    unless ['forward','reverse'].include?(direction)
      log.error('Please provide "forward" or "reverse" for direction')
      return
    end
    if speed < 0 or speed > 10
      log.error('Please select a speed between 0 and 10')
      return
    end
    if time < 1 or time > 60
      log.error('Please select a time between 1 and 60 seconds')
      return
    end

    log.info("Moving train #{direction} direction at speed #{speed} for #{time} seconds...")
    Commands.throttle([speed, direction], comms, log)
    sleep(time)
    Commands.stop(nil, comms, log)
    log.info('Move complete')
  end
end