require 'logger'
require 'colorize'
class Log

  @loggers = []

  def initialize(file='~/.bolttrain/runner.log', console_level='INFO', file_level='DEBUG')
    file = File.expand_path(file)
    dir = File.split(file)[0]
    Dir.mkdir(dir) unless File.exist?(dir)
    @console = Logger.new(STDOUT, 
      level: console_level,
      formatter: proc { |sev, datetime, progname, msg| "#{msg}\n" })
    @file = Logger.new(file, 'daily', level: file_level)
  end

  def set_console_level(level)
    @console.level = level
  end

  def set_file_level(level)
    @file.level = level
  end

  def debug(msg, console=true, file=true)
    @console.debug(msg) if console
    @file.debug(msg) if file
  end

  def debug_console(msg)
    debug(msg, true, false)
  end

  def debug_file(msg)
    debug(msg, false, true)
  end

  # Just for printing help text to the console. Doesn't need to be logged.
  def help(msg)
    @console.info(msg.cyan)
  end

  def info(msg, console=true, file=true)
    @console.info(msg.green) if console
    @file.info(msg) if file
  end

  def info_console(msg)
    info(msg, true, false)
  end

  def info_file(msg)
    info(msg, false, true)
  end

  def warn(msg, console=true, file=true)
    @console.warn(msg.yellow) if console
    @file.warn(msg) if file
  end

  def warn_console(msg)
    warn(msg, true, false)
  end

  def warn_file(msg)
    warn(msg, false, true)
  end

  def error(msg, console=true, file=true)
    @console.error(msg.red) if console
    @file.error(msg) if file
  end

  def error_console(msg)
    error(msg, true, false)
  end

  def error_file(msg)
    error(msg, false, true)
  end

  def fatal(msg, console=true, file=true)
    @console.fatal(msg.red) if console
    @file.fatal(msg) if file
  end

  def fatal_console(msg)
    fatal(msg, true, false)
  end

  def fatal_file(msg)
    fatal(msg, false, true)
  end

  def close
    @console.close
    @file.close
  end
end