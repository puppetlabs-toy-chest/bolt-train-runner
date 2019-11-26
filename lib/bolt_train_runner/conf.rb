require 'yaml'

class Conf
  attr_reader :CONFFILE

  CONFFILE = File.expand_path('~/.bolttrain/config')
  CONFDIR = File.split(CONFFILE)[0]
  Dir.mkdir(CONFDIR) unless File.exist?(CONFDIR)
  File.write(CONFFILE, "---\n{}") unless File.exist?(CONFFILE)

  def self.load_conf
    YAML.load_file(CONFFILE)
  end

  def self.save_conf(conf)
    File.write(CONFFILE, conf.to_yaml)
  end

  def self.debug
    conf = load_conf
    conf['debug'] || false
  end
end