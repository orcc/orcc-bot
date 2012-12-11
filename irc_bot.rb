#!/usr/bin/env ruby1.9.1

require 'daemons'

unless ARGV.length > 0
  puts "Usage: irc_bot.rb [start|stop|restart] <channel (without the # sign)>"
  exit
end

currentDir = File.realdirpath(File.dirname(__FILE__))
logDir = File.join(currentDir, 'logs')

unless Dir.exists?(logDir) then
	Dir.mkdir(logDir)
else
	for f in Dir.glob(File.join(logDir, "*.{log,output}"))
		File.delete(f)
		puts f + " deleted..."
	end
end

args = [ARGV.first, '-f', '--'] + ARGV.slice(1, ARGV.length)

options = {
	:app_name   => "irc_bot",			# app name
	:ARGV       => args,				# correctly set daemon arguments
	:backtrace  => true,				# write the last exception if any
	:monitor    => true,				# create a process to monitor and restart if crashes
	:dir_mode	=> :normal,				# paths are considered absolutes or relative
	:log_output => true,				# does the logs should be written ?
    :log_dir	=> logDir				# dir to write logs files
}

Daemons.run(File.join(currentDir, 'bot.rb'), options)
