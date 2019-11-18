require 'bolt_train_runner/conf'
require 'bolt_train_runner/comms'
require 'colorize'

module Commands
  def self.connect(args)
    conf = Conf.load_conf
    if !args.empty? && args[0] =~ /help/i
      puts 'Command: connect'.cyan
      puts 'Syntax: connect [server:port]'.cyan
      puts 'If called with no argument, it will attempt to use the last specified server:port'.cyan
      puts 'If this is the first time connect was called with no arguments, it will prompt you for the server and port'.cyan
      return
    end
    if args.empty?
      server = conf['server']
      unless server
        print 'Please enter server:port [10.0.7.82:12080] > '
        server = gets.chomp
        server = '10.0.7.82:12080' if server.empty?
      end
    else
      server = args[0]
    end
    conf['server'] = server
    Conf.save_conf(conf)

    puts "Connecting to ws://#{server}/json/".green
    comms = Comms.new(server)
    puts "Connected".green
    return comms
  end
end