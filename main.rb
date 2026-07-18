# New project Hangman

# When a new game is started, your script should load in the dictionary
# and randomly select a word between 5 and 12 characters long for the secret word.

require_relative "lib/game"

puts "Load saved game? (y/n)"

choice = gets.chomp.downcase

game = 
  if choice == "y"
    Game.new(load: true)
  else
    Game.new
  end
