#!/usr/bin/env ruby1.9.1
require 'cinch'
require 'chronic'

MAX_MSGS = 10000

class History
  include Cinch::Plugin

  class HistoryMsg < Struct.new(:user, :time, :channel, :msg)
    def to_s
      "[#{time.strftime "%H:%M:%S"}] #{user}: #{msg}"
    end
  end

  def initialize(*args)
    super
    @history = []
  end

  match(/(.*)/, :use_prefix => false)

  def execute(m)
    if m.message =~ /^!history(.*)/ then
      # send history with private messages to the user depending on the channel
      begin
        time = Chronic.parse($1, :context => :past)
        if time == nil then
          raise "wrong date format"
        else
          if m.channel? then
            m.user.msg "history on the channel " + m.channel + " after " + time.to_s + ":"
            @history.each { |msg| m.user.msg(msg) if msg.channel == m.channel and msg.time >= time }
          else
            m.user.msg "history after " + time.to_s + ":"
            @history.each { |msg| m.user.msg(msg) if msg.time >= time }
          end
        end
      rescue
        m.user.msg "please give a date: !history yesterday, !history 2 hours ago, !history 6 in the morning, etc."
        m.user.msg "more documentation is available at http://chronic.rubyforge.org/files/README.html"
      end
    elsif m.channel? then
      # only record messages on the channel
      @history << HistoryMsg.new(m.user, Time.now, m.channel, m.message)
      if @history.size > MAX_MSGS then
        @history.delete_at(0)
      end
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
    m.reply "available commands:\n!help\n!history date (date being written in natural language, e.g. two hours ago)"
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

