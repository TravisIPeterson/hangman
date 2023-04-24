require 'yaml'

class GameTools

    attr_accessor :word, :word_array, :guess_array

    def initialize
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

end

hangman = GameTools.new

puts "Welcome to Hangman! The computer has randomly selected a word for you (between 5 and 12 letters)."

incorrect = 0
win = false

while incorrect < 6
    puts "\n\n#{hangman.guess_array.join()}\n\n
    You have #{6 - incorrect} guesses left. Which letter would you like to guess?"
    guess = gets.chomp.downcase
    correct = false
    hangman.word_array.each_with_index do | letter, index|
        if letter == guess
            hangman.guess_array[index] = guess
            correct = true
        end
    end
    if correct == false
        puts "Sorry, that letter isn't in the word."
        incorrect += 1
    elsif hangman.guess_array.join() == hangman.word_array.join()
        incorrect = 7
        win = true
    end
end
if win == true
    puts "You win! The word was #{hangman.word.chomp}."
else
    puts "Better luck next time, champ. The word was #{hangman.word.chomp}."
end