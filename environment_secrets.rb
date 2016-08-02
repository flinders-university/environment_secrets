#!/usr/bin/ruby

# Designed to make it ever so slightly simpler to export environment secrets

# Gem install colorize
require 'colorize'

version = 1.0

template= File.new("#{File.expand_path('~')}/.environment_secrets", "r").read + "\n# New keys #{Time.now.strftime("%-l:%M %p, %-d %B %Y")}" || "# This file exists...\nexport ENVIRONMENT_SECRETS=true\n"

# Prompt for user input
def prompt(*args)
    print(*args)
    gets.strip
end

# Clear everything
system "clear" or system "cls"

puts "[Environment Secret Generator - #{version}]".blue
puts "\nInteractively Generating environment secrets...\n".red

numsecrets = prompt("Enter the number of variables you wish to enter: ")
numtimes = 1

while numtimes <= numsecrets.to_i
  puts "\nVariable #{numtimes} (string):"
  numtimes+=1
  var = prompt("Enter variable name: ")
  val = prompt("Enter variable value: ")
  template = template + "\nexport #{var.strip.upcase}=\"#{val.strip}\"\n"
end

puts "\nUpdated contents of ~/.environment_secrets\n".green
puts template
puts "\n"

puts "Overwrite current .environment_secrets...".red
continue = prompt("Does this look right? [Y/n]")

if continue.to_s == "y" || continue.to_s == "Y"
  if File.write("#{File.expand_path('~')}/.environment_secrets", template)
    puts "👍  Updated successfully".green
    exec( "$EDITOR +999 ~/.environment_secrets" )
  else
    puts "👎  Couldn't update secrets".red
  end
else
  puts "👎  Sequence aborted...".red
end
