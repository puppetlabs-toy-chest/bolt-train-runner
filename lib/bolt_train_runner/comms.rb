require 'websocket-client-simple'
require 'json'
require 'bolt_train_runner/conf'
require 'bolt_train_runner/log'

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
  @log = nil

  def initialize(server, log)
    @log = log
    @ws = WebSocket::Client::Simple.connect("ws://#{server}/json/", @log)
    @ws.on :message do |msg, logger|
      data = JSON.parse(msg.data)
      logger.debug("Received #{data}\n> ")
    end
    @ws.on :error do |e, logger|
      logger.error("Error from Websocket: #{e}")
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
    message = JSON.generate(message)
    @log.debug("Sending #{message}")
    @ws.send(message)
  end

end
