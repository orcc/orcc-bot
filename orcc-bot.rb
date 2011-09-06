require 'cinch'

class AutoHello
  include Cinch::Plugin

  listen_to :join
  def listen(m)
	unless m.user.nick == bot.nick
      m.reply "Hello #{m.user.nick}"
    end
  end
end

bot = Cinch::Bot.new do
  configure do |c|
    c.server          = "irc.freenode.org"
    c.nick            = "roo-bot"
    c.channels        = ["#orcc"]
    c.verbose         = true
    c.plugins.plugins = [AutoHello]
  end
end

bot.start
