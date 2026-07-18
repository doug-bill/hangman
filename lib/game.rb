
# This thing creates the word that will be used on the Hangman game

class Game
  
    
  def initialize
    @secret_word = create_secret_word
    # @secret_word
    @right_letters = []
    @wrong_letters = []
    @guesses = 0
    #@guesses_left = 6
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
    #puts @secret_word.chars.map { |c| "_" }.join(" ")
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

  def start

    display_hangedman
    display_word
    input = ""

    while @guesses < 6

      puts "Guess a letter: \n"

      if @wrong_letters.empty?
        puts "Missed letters: No missed letters yet."
      else
        puts "Missed letters: #{@wrong_letters}"
      end

      loop do
        input = gets.chomp.downcase
        break if valid_input?(input)

        puts "Invalid input! Type only one letter"
      end

      if @wrong_letters.include?(input) || @right_letters.include?(input)
        puts "You alredy tried that!!! Guess another letter"
      
      elsif @secret_word.include?(input)
        @right_letters << input
        puts "Correct !"
     
      else
        puts "You guessed wrong!"
        @wrong_letters << input
        @guesses += 1
        display_hangedman
      end

      puts(@secret_word.chars.map { |c| @right_letters.include?(c) ? c : "_" }.join(" "))
 
      if @secret_word.chars.uniq.all? { |c| @right_letters.include?(c) }
        puts "Congratulations you've guessed everything right!"
        sleep 1.5
        exit
      end

      if @guesses == 6
        puts "You were Hanged (x_x) - GAME OVER!!!! "
        sleep 1.5
        puts "The secret word was #{@secret_word}"
        exit
      end
    end
  end

  def valid_input?(input)
    input.length == 1 && input.match?(/[[:alpha:]]/)
  end

end

# Game.new.display_hangedman
# Game.new.display_word
#Game.new.start


