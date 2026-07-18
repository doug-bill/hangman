# New project Hangman

# When a new game is started, your script should load in the dictionary
# and randomly select a word between 5 and 12 characters long for the secret word.

require_relative "lib/game"
require_relative "lib/title"
require "colorize"

Title.new

puts "                    [N] New Game | [L] Load Game  | [Q] Quit".green

game = nil

loop do

  choice = gets.chomp.downcase

  case choice
  when "n"
    print "\x1B[1;1H\x1B[2J"
    game = Game.new
    break
  when "l"
    print "\x1B[1;1H\x1B[2J"
    game = Game.new(load: true)
    break
  when "q"
    puts "Bye then!"
    exit
  else
    puts "Invalid option! Please choose N, L or Q."
  end
end

game.start