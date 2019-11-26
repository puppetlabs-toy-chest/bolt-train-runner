#!/usr/bin/env ruby

require 'rubygems'
require 'colorize'
require 'bolt_train_runner/comms'
require 'bolt_train_runner/session_runner'
require 'bolt_train_runner/log'

# Load all commands
Dir[File.join(File.absolute_path(__dir__) + '/bolt_train_runner/commands') + "/**/*.rb"].each do |file|
  require file
end

# TODO:
#   Add a lot more error handling
#   Figure out best way to verify commands worked given that responses from JMRI are async
#   Figure out why it gets multiple messages back each time
#   Make debug output show what method/command the output is from
#   Make debug output not screw with the console prompt
#   Add more user control over logging (where it goes, log level, etc.)


class BoltTrainRunner

  def run
    comms = nil
    session_runner = nil
    log = Log.new
    log.help('Welcome to the Bolty McBoltTrain Runner! Choo choo!')
    log.help('To list all commands, enter "help"')
    log.help('For help with a specific command, enter "<command> help"')
    log.help('First order of business: run "connect" to connect to the JMRI server')

    loop do
      print '> '
      input = gets.chomp
      args = input.split(' ')
      command = args.shift
      log.info_file("Console command: #{input}")

      case command
      when /^help$/i
        help(log)
      when /^connect$/i
        newcomms = Commands.connect(args, log)
        comms = newcomms if newcomms
      when /^disconnect$/i
        session_runner.stop if session_runner
        session_runner = nil
        Commands.disconnect(comms, log)
        comms = nil
      when /^sessions$/i
        session_runner = Commands.sessions(args, comms, session_runner, log)
      when /^debug$/i
        Commands.debug(args, log)
      when /^exit$/i
        Commands.exit_program(comms, session_runner, log)
      else
        if Commands.respond_to?(command)
          # The commands for directly manipulating the train should all
          # accept "args" and "comms" parameters. Because the CLI will pass
          # in args as an array and the session runner will pass in a hash,
          # these commands must be able to handle both.
          Commands.send(command.to_sym, args, comms, log)
        else
          log.warn("Unknown command: #{command}")
        end
      end
    end
  end

  def help(log)
    log.help('Available commands:')
    log.help('help - This help text')
    log.help('connect - Connect to the Bolt Train JMRI JSON server')
    log.help('disconnect - Disconnect from the JMRI server')
    log.help('power - Turn power on or off to the train')
    log.help('throttle - Set throttle to a value between 0 and 10')
    log.help('move - Move the train in the given direction at the given speed for a certain length of time')
    log.help('stop - Stop the train')
    log.help('exit - Exit program')
  end

end