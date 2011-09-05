#!/usr/bin/env ruby1.9.1
require 'cinch'

class History
  include Cinch::Plugin

  class HistoryMsg < Struct.new(:user, :time, :channel, :msg)
    def to_s
      "[#{time.strftime "%H:%M:%S"}] #{channel} #{user}: #{msg}"
    end
  end

  def initialize(*args)
    super
    @history = []
  end

  match(/(.*)/, :use_prefix => false)

  def execute(m)
    if m.message =~ /!history(.*)/ then
      # send history with private messages to the user depending on the channel
      m.user.msg "history:"
      @history.each { |msg| m.user.msg(msg) if (not m.channel?) or msg.channel == m.channel }
    elsif m.channel? then
      # only record messages on the channel
      @history << HistoryMsg.new(m.user, Time.now, m.channel, m.message)
    end
  end

end

class Leave
  include Cinch::Plugin
  
  match /leave (.+)/

  def execute(m)
    if not m.channel? then
      if m.message =~ /!leave NOW!/ then
        m.bot.channels.each { |c| c.msg "#{m.user.nick} asked me to leave... bye all!" }
        m.bot.quit
      else
	m.reply "incorrect password. I'm not leaving!"
      end
    end
  end

end

class Help
  include Cinch::Plugin
  
  match /help/

  def execute(m)
    m.reply "available commands: !help and !history"
  end

end

# quit unless our script gets two command line arguments
unless ARGV.length == 1
  puts "Usage: bobot.rb channel (without the # sign)"
  exit
end

channel = ARGV[0]

bot = Cinch::Bot.new do
  configure do |c|
    c.server = "irc.freenode.org"
    c.channels = ["#" + channel]
    c.messages_per_second = 0.5
    c.nick = channel + "-bot"
    c.plugins.plugins = [Help, History, Leave]
    c.verbose = true
  end
end

bot.start

