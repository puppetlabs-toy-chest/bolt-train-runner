require 'bolt_train_runner/comms'
require 'bolt_train_runner/commands/throttle'
require 'bolt_train_runner/commands/stop'
require 'colorize'

module Commands
  def self.move(args, comms)
    unless comms
      puts 'Please connect first'.red
      return
    end
    if args.empty? || args[0] =~ /help/i
      puts 'Command: move'.cyan
      puts 'Syntax: move <forward|reverse> <speed 0-10> <time 1-60>'.cyan
      puts 'Move the train the given direction at the given speed for the given number of seconds'.cyan
      puts 'Note that the power must be on first'.cyan
      return
    end

    if args.length < 3
      puts 'Please provide direction, speed, and time'.red
      return
    end
    direction = args[0]
    speed = args[1].to_i
    time = args[2].to_i
    unless ['forward','reverse'].include?(direction)
      puts 'Please provide "forward" or "reverse" for direction'.red
      return
    end
    if speed < 0 or speed > 10
      puts 'Please select a speed between 0 and 10'.red
      return
    end
    if time < 1 or time > 60
      puts 'Please select a time between 1 and 60 seconds'.red
      return
    end

    puts "Moving train #{direction} direction at speed #{speed} for #{time} seconds...".green
    Commands.throttle([speed,direction],comms)
    sleep(time)
    Commands.stop(comms)
    puts 'Move complete'.green
  end
end