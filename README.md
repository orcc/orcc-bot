orcc-bot
========

An IRC bot written in Ruby using the cinch framework

Requirements
========
 * ruby 1.9.1
 * cinch
 * chronic

On Ubuntu, type with root permissions :

    apt-get install ruby1.9.1
    gem install cinch
    gem install chronic

How-to use
========
Simply launch the script with command :

    /path/to/irc_bot.rb <channel_without_#>

If you want to launch the script as a service, edit /etc/rc.local to add the command ended with '&'.
