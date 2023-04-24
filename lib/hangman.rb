require 'yaml'

class GameTools

    attr_accessor :word, :word_array, :guess_array, :incorrect

    def initialize(word = "", word_array = "", guess_array = "", incorrect = 0)
        @word = word
        @word_array = word_array
        @guess_array = guess_array
        @incorrect = incorrect
    end

    def game_start
        @word = random_word
        @word_array = create_word_array
        @guess_array = create_guess_array
    end

    def random_word
        word = ""
        while word.length < 6 || word.length > 12
            word = File.readlines('dictionary/common_words.txt').sample
        end
        return word
    end

    def create_word_array
        word_array = @word.split('')
        word_array.pop() #Eliminate \n element from array
        return word_array
    end

    def create_guess_array
        guess_array = Array.new(@word.length, '_')
        guess_array.pop() #Length includes \n element, so popping makes this array the correct length
        return guess_array
    end

    def to_yaml
        YAML.dump ({
            :word => @word,
            :word_array => @word_array,
            :guess_array => @guess_array,
            :incorrect => @incorrect
        })
    end

    def self.from_yaml(file)
        data = YAML.load(File.read("saves/#{file}.yml"))
        p data
        self.new(data[:word], data[:word_array], data[:guess_array], data[:incorrect])
    end

end

hangman = GameTools.new
hangman.game_start

puts "Welcome to Hangman! The computer has randomly selected a word for you (between 5 and 12 letters). Also, at any time you can type 'save' or 'load' in order to save this game or load a previous game."

win = false

while hangman.incorrect < 6
    puts "\n\n#{hangman.guess_array.join()}\n\n
    You have #{6 - hangman.incorrect} guesses left. Which letter would you like to guess?"
    guess = gets.chomp.downcase
    if guess.downcase == "save"
        puts "What would you like to name this save?"
        name = gets.chomp.downcase
        File.open("saves/#{name}.yml", "w") do |file|
            file.write(hangman.to_yaml)
        end
        puts "Your game has been saved."
        exit
    elsif guess.downcase == "load"
        puts "What's the name of your save file?"
        name = gets.chomp.downcase
        if File.exist? "saves/#{name}.yml"
            hangman = GameTools.from_yaml(name)
            puts "Success! Your game has been loaded."
        else
            puts "Sorry, I don't see a save file with that name."
        end
    else
        until guess.length == 1
            puts "Guess one letter at a time please."
            guess = gets.chomp
        end
        correct = false
        hangman.word_array.each_with_index do | letter, index|
            if letter == guess
                hangman.guess_array[index] = guess
                correct = true
            end
        end
        if correct == false
            puts "Sorry, that letter isn't in the word."
            hangman.incorrect += 1
        elsif hangman.guess_array.join() == hangman.word_array.join()
            hangman.incorrect = 7
            win = true
        end
    end
end
if win == true
    puts "You win! The word was #{hangman.word.chomp}."
else
    puts "Better luck next time, champ. The word was #{hangman.word.chomp}."
end