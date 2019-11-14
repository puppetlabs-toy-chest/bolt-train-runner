#!/usr/bin/env ruby

require 'rubygems'
require 'colorize'
require 'bolt_train_runner/comms'

# Load all commands
Dir[File.join(File.absolute_path(__dir__) + '/bolt_train_runner/commands') + "/**/*.rb"].each do |file|
  require file
end

# TODO:
#   Add a lot more error handling
#   Add thread for consuming session files and issuing commands
#   Figure out best way to verify commands worked given that responses from JMRI are async
#   Figure out why it gets multiple messages back each time
#   Make debug output show what method/command the output is from
#   Make debug output not screw with the console prompt
#   Changing debug on or off and reconnecting doesn't actually seem to work to change debug level
#   Add a way to log to a file in addition to the console


class BoltTrainRunner

  def run
    comms = nil
    puts 'Welcome to the Bolty McBoltTrain Runner! Choo choo!'.cyan
    puts 'To list all commands, enter "help"'.cyan
    puts 'For help with a specific command, enter "<command> help"'.cyan
    puts 'First order of business: run "connect" to connect to the JMRI server'.cyan
    loop do
      print '> '
      input = gets.chomp
      args = input.split(' ')
      command = args.shift
      case command
      when /^help$/i
        help
      when /^connect$/i
        newcomms = Commands.connect(args)
        comms = newcomms if newcomms
      when /^disconnect$/i
        Commands.disconnect(comms)
        comms = nil
      when /^debug$/i
        Commands.debug(args)
      when /^power$/i
        Commands.power(args, comms)
      when /^throttle$/i
        Commands.throttle(args, comms)
      when /^move$/i
        Commands.move(args, comms)
      when /^exit$/i
        Commands.exit_program(comms)
      else
        puts "Unknown command: #{command}".red
      end
    end
  end

  def help
    puts 'Available commands:'.cyan
    puts 'help - This help text'.cyan
    puts 'connect - Connect to the Bolt Train JMRI JSON server'.cyan
    puts 'disconnect - Disconnect from the JMRI server'.cyan
    puts 'power - Turn power on or off to the train'.cyan
    puts 'throttle - Set throttle to a value between 0 and 10'.cyan
    puts 'move - Move the train in the given direction at the given speed for a certain length of time'.cyan
    puts 'exit - Exit program'.cyan
  end

end