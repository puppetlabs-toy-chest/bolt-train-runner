require 'json'

# Load all commands
Dir[File.join(File.absolute_path(__dir__) + '/bolt_train_runner/commands') + "/**/*.rb"].each do |file|
  require file
end

# This class manages a thread which monitors a directory that the bolt-train-api will
# place session files in.  As these files show up, the thread should read them and
# issue the commands, delete the session file, then move to the next oldest file in the directory.

class SessionRunner

  @session_thread = nil
  @kill_thread = false

  def initialize(comms, session_dir)
    raise 'comms must not be nil' if comms.nil?
    raise 'session_dir must not be nil' if session_dir.nil?
    raise 'session_dir does not exist' unless File.exist?(session_dir)

    @session_dir = session_dir
    @comms = comms
  end

  def start
    @session_thread = Thread.new { run_thread }
  end

  def stop
    @kill_thread = true
    puts 'Stopping Session Runner'.magenta
    @session_thread.join if @session_thread
  end

  def run_thread
    while !@kill_thread
      files = Dir["#{@session_dir}/*"].sort_by { |f| File.mtime(f) }
      files.each do |f|
        begin
          data = JSON.parse(File.read(f))
        rescue
          next
        end
        session = data['session']
        email = session['email']
        puts "[Session Runner] Starting session for #{email}".magenta
        commands = session['commands']
        commands.each do |args|
          c = args['command']
          args.delete('command')
          puts "[Session Runner] Sending command #{c}".magenta
          puts "[Session Runner] Arguments = #{args}".magenta
          Commands.send(c, args, @comms)
        end
        File.delete(f)
        puts "[Session Runner] Session for #{email} complete".magenta
      end
    end
  end

end