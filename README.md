orcc-bot
========

An IRC bot written in Ruby using the cinch framework

Requirements
========
 * ruby 1.9.1
 * cinch
 * chronic
 * daemons

On Ubuntu, type with root permissions :

    apt-get install ruby1.9.1
    gem install cinch chronic daemons

How-to use
========
Simply launch the script with command :

    /path/to/irc_bot.rb [start|stop|restart] <channel without the first #>

If you want to launch the script at startup, simply add the start command in /etc/rc.local.
