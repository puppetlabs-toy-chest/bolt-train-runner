require 'bolt_train_runner/comms'
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

    message = {
      'type'   => 'throttle',
      'method' => 'put',
      'data'   => {
        'throttle' => 'bolttrain',
        'address'  => '6871',
        'speed'    => "#{speed/10.0}",
        'forward'  => "#{direction == 'forward'}"
      }
    }
    comms.send_message(message)
    puts "Train moving #{direction} at speed #{speed}".green
    puts "Waiting #{time} seconds".green
    sleep(time)
    puts "Stopping train".green
    message = {
      'type'   => 'throttle',
      'method' => 'post',
      'data'   => {
        'throttle' => 'bolttrain',
        'address'  => '6871',
        'speed'    => '0'
      }
    }
    comms.send_message(message)
    puts 'Move complete'.green
  end
end