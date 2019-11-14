# BoltTrainRunner

This is a CLI tool for communicating with the Bolt Train JMRI JSON server. It will allow you to control the Bolt train in real time. It will also serve as the executor, reading session files laid down by the bolt-train-api server, and sending the appropriate JMRI commands to implement the commands in those session files.

## Installation

This is packaged as a gem on RubyGems. So all you need to do to install is:

```ruby
gem install bolt_train_runner
```

## Usage

To start the program, simply run `bolt_train` from the command line. This will start the bolt-train-runner shell.  Type `help` for a list of commands, and `<command> help` for information on how to use each command.

The first command you must run before all others is `connect`.  This will open a websocket connection to the JMRI JSON server. After successfully connecting, the server you connected to will be saved to `~/.bolttrain.conf`, so you will not need to type the server information in again.

Turning debug mode on by doing `debug on` will print the JSON blobs sent to and received from the the JMRI JSON server.

## Development

After checking out the repo, do a `bundle install`. Then, you can do `bundle exec rake build` to create the gem in the `pkg` folder. You may then install this local copy of the gem using `gem install`.

Using `bundle exec rake install` will probably also work in place of the above steps.

To release a new version of the gem, do `bundle exec rake release`.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/bolt_train_runner.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
