require 'bolt_train_runner/conf'
require 'bolt_train_runner/log'

module Commands
  def self.debug(args, log)
    if args.empty? || args[0] =~ /help/i
      log.help('Command: debug')
      log.help('Syntax: debug <on|off>')
      #Should fix this at some point 
      log.help('Turns debug logging on or off. Choice will be persistent across program invocations.')
      return
    end
    state = args[0]
    if !['on','off'].include?(state)
      log.error('Debug must be called with either "on" or "off"')
      return
    end
    conf = Conf.load_conf
    conf['debug'] = state == 'on'
    Conf.save_conf(conf)
    state == 'on' ? log.set_console_level('DEBUG') : log.set_console_level('INFO')
    log.info("Debug mode #{state}")
  end
end
