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

  match(/.*/, :use_prefix => false)

  def execute(m)
    if m.channel? then
      if $1 == "!history" then
        m.user.msg "history:"
        @history.each { |msg| m.user.msg(msg) if msg.channel == m.channel }
      elsif $1 == "!clear_history" then
        @history = []
      else
        @history << HistoryMsg.new(m.user, Time.now, m.channel, m.message)
      end
    end
  end

end

class Help
  include Cinch::Plugin
  
  match /help/

  def execute(m)
    if m.channel? then
      m.reply "Available commands: !help and !history"
    else
      if m.message =~ /leave (.+)/ then
        if $1 == "NOW!" then
          m.bot.channels.each { |c| c.msg "#{m.user.nick} asked me to leave... bye all!" }
          m.bot.quit
        else
          m.reply "incorrect password. I'm not leaving!"
        end
      end
    end
  end

end

bot = Cinch::Bot.new do
  configure do |c|
    c.server = "irc.freenode.org"
    c.channels = ["#test-bobot"]
    c.nick = "bobot_xyz"
    c.plugins.plugins = [Help, History]
  end
end

bot.start

