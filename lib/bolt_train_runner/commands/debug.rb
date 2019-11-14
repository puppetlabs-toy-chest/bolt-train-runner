require 'colorize'
require 'bolt_train_runner/conf'

module Commands
  def self.debug(args)
    if args.empty? || args[0] =~ /help/i
      puts 'Command: debug'.cyan
      puts 'Syntax: debug <on|off>'.cyan
      #Should fix this at some point 
      puts 'Turns debug logging on or off. Will require disconnecting and reconnecting to take effect.'.cyan
      puts 'Choice will be persistent across program invocations.'.cyan
      return
    end
    state = args[0]
    if !['on','off'].include?(state)
      puts 'Debug must be called with either "on" or "off"'.red
      return
    end
    conf = Conf.load_conf
    conf['debug'] = state == 'on'
    Conf.save_conf(conf)
    puts "Debug mode #{state}".green
  end
end
