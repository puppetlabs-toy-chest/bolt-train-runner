require 'bolt_train_runner/conf'
require 'bolt_train_runner/comms'
require 'bolt_train_runner/log'

module Commands
  def self.connect(args, log)
    conf = Conf.load_conf
    if !args.empty? && args[0] =~ /help/i
      log.help('Command: connect')
      log.help('Syntax: connect [server:port]')
      log.help('If called with no argument, it will attempt to use the last specified server:port')
      log.help('If this is the first time connect was called with no arguments, it will prompt you for the server and port')
      return
    end
    if args.empty?
      server = conf['server']
      unless server
        prompt = 'Please enter server:port [10.0.7.82:12080] > '
        print prompt
        server = gets.chomp
        server = '10.0.7.82:12080' if server.empty?
        log.info_file("#{prompt} #{server}")
      end
    else
      server = args[0]
    end
    conf['server'] = server
    Conf.save_conf(conf)

    log.info("Connecting to ws://#{server}/json/")
    comms = Comms.new(server, log)
    log.info("Connected")
    return comms
  end
end