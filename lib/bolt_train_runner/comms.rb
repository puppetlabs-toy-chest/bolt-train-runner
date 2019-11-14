require 'websocket-client-simple'
require 'json'
require 'colorize'
require 'bolt_train_runner/conf'
require 'pry-byebug'

# Sending and receiving responses is a little bit funky
# Since we have to receive messages asynchronously, and because
# the server sometimes sends back more than one message to a given
# command, and because the server will send out status messages
# periodically, it is hard to verify that the command you sent
# was received correctly. So for now, it's just sending the command
# and not checking the result.

class Comms

  @ws = nil
  @heartbeat_thread = nil
  @consumer_thread = nil
  @kill_threads = false
  @queue = []

  def initialize(server)
    debug = Conf.debug
    @ws = WebSocket::Client::Simple.connect("ws://#{server}/json/")
    @ws.on :message do |msg|
      data = JSON.parse(msg.data)
      puts "Received #{data}" if (data['type'] != 'hello') if debug
    end
    @ws.on :error do |e|
      puts "Error from Websocket: #{e}".red
    end

    @heartbeat_thread = Thread.new { run_heartbeat }
  end

  def disconnect
    @kill_threads = true
    @heartbeat_thread.join if @heartbeat_thread
  end

  def run_heartbeat
    count = 0
    check_interval = 0.5
    ping_interval = 10
    while !@kill_threads
      count = count % ping_interval
      if count == 0
        message = send_message({'type'=>'ping'})
      end
      count += check_interval
      sleep(check_interval)
    end
  end

  # Expects a hash with the correctly formed message, which
  # will get transformed to a JSON string by this function
  def send_message(message)
    debug = Conf.debug
    message = JSON.generate(message)
    puts "Sending #{message}" if debug
    @ws.send(message)
  end

end
