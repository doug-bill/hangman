require "json"


# This thing creates the word that will be used on the Hangman game
class Game

  def initialize(load: false)
    if load == true
      load_save
    else
      new_game
    end
    start
  end

  def load_save
    data = JSON.parse(File.read("./saves/savefile.json"))

    @secret_word = data["secret"]
    @right_letters = data["right_letters"]
    @wrong_letters = data["wrong_letters"]
    @guesses = data["guessed"]
    @input = ""
  end

  def new_game
    @secret_word = create_secret_word
    @right_letters = []
    @wrong_letters = []
    @guesses = 0
    @input = ""
  end

  def savegame

    player_data = {
      secret: @secret_word,
      right_letters: @right_letters,
      wrong_letters: @wrong_letters,
      guessed: @guesses
    }

    # Convert the hash to a JSON string and save it
    File.write("./saves/savefile.json", JSON.pretty_generate(player_data))

  end
  
  def create_secret_word
    File.open("./lib/google-10000-english-no-swears.txt", "r") do |file|
      dict = Array.new(file.select { |word| word.chomp.length.between?(5, 12) }.map(&:chomp))
      word = dict.sample
      return word
    end
  end
  
  def display_word
    puts "The Word is: #{@secret_word.chars.map { |c| '_' }.join(' ')} "
  end

  def display_hangedman

    stages = [
      " +--+\n |  |\n    |\n    |\n    |\n    |\n=====",  # 0
      " +--+\n |  |\n O  |\n    |\n    |\n    |\n=====",  # 1
      " +--+\n |  |\n O  |\n |  |\n    |\n    |\n=====",  # 2
      " +--+\n |  |\n O  |\n/|  |\n    |\n    |\n=====",  # 3
      " +--+\n |  |\n O  |\n/|\\ |\n    |\n    |\n=====", # 4
      " +--+\n |  |\n O  |\n/|\\ |\n/   |\n    |\n=====", # 5
      " +--+\n |  |\n O  |\n/|\\ |\n/ \\ |\n    |\n=====" # 6
    ]
    puts stages[@guesses]
  end

  def display_lives
    full = ("♥ " * (6 - @guesses)).red
    empty = ("♡ " * @guesses).light_black

    return "Lives        #{full}#{empty}"
  end

  def game_ui

    puts <<~UI
    ╔═══════════════════════════════════════════════╗
    ║                  HANGMAN                      ║
    ╠═══════════════════════════════════════════════╣
    ║ #{display_lives.ljust(20)}                     ║
    ║ Wrong letters #{@wrong_letters.join(' ').ljust(20)}            ║
    ║ Save          $                               ║
    ║ Quit          !                               ║
    ╚═══════════════════════════════════════════════╝
    UI
  end

  def start
    game_ui
    display_hangedman
    display_word

    while @guesses < 6
      puts "Type any letter to make a guess:\n"

      # if @wrong_letters.empty?
      #   puts "Missed letters: No missed letters yet."
      # else
      #   puts "Missed letters: #{@wrong_letters}"
      # end

      loop do
        @input = gets.chomp.downcase
        break if valid_input?(@input)

        puts "Invalid @input! Type only one letter"
      end

      if @input == "$"
        savegame
        puts "Game saved!"
        next
      elsif @input == "!"
        quit_game
      else
        process_guess(@input)
      end
    end
  end

  def valid_input?(input)
    input.length == 1 && @input.match?(/[[:alpha:][$][!]]/)
  end

  def process_guess(input)

      if (@wrong_letters.include?(input) || @right_letters.include?(input)) 
        puts "You alredy tried that!!! Guess another letter"
        sleep 1.5
      elsif @secret_word.include?(input)
        @right_letters << input
        puts "Correct !"
        sleep 1.5
      
      else
        puts "You guessed wrong!"
        @wrong_letters << input
        @guesses += 1
        sleep 1.5
      
      end
      #sleep 1.5
      print "\x1B[1;1H\x1B[2J"
      game_ui
      display_hangedman

      puts(@secret_word.chars.map { |c| @right_letters.include?(c) ? c : "_" }.join(" "))
 
      if @secret_word.chars.uniq.all? { |c| @right_letters.include?(c) }
        puts "Congratulations you've guessed everything right!"
        sleep 1.5
        restart
      end

      if @guesses == 6
        puts "You were Hanged (x_x) - GAME OVER!!!! "
        sleep 1.5
        puts "The secret word was #{@secret_word}\n"
        restart
      end

  end

  def quit_game
    puts "Until next time!!"
    sleep 1.5
    exit
  end

  def restart
    puts "Play Again ? (y/n)"
    input = gets.chomp.downcase
    if input == "y"
      new_game
      print "\x1B[1;1H\x1B[2J"
      start
    else
     quit_game
    end
  end
end
