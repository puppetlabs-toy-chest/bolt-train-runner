#!/usr/bin/env ruby

require 'rubygems'
require 'colorize'
require 'bolt_train_runner/comms'
require 'bolt_train_runner/session_runner'

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
    session_runner = nil
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
      when Commands.respond_to?(command)
        puts 'Commands can run this'
      when /^connect$/i
        newcomms = Commands.connect(args)
        comms = newcomms if newcomms
      when /^disconnect$/i
        session_runner.stop if session_runner
        session_runner = nil
        Commands.disconnect(comms)
        comms = nil
      when /^sessions$/i
        session_runner = Commands.sessions(args, comms, session_runner)
      when /^debug$/i
        Commands.debug(args)
      when /^exit$/i
        Commands.exit_program(comms, session_runner)
      else
        if Commands.respond_to?(command)
          # The commands for directly manipulating the train should all
          # accept "args" and "comms" parameters. Because the CLI will pass
          # in args as an array and the session runner will pass in a hash,
          # these commands must be able to handle both.
          Commands.send(command.to_sym, args, comms)
        else
          puts "Unknown command: #{command}".red
        end
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
    puts 'stop - Stop the train'.cyan
    puts 'exit - Exit program'.cyan
  end

end