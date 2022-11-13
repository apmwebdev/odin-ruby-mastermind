class HumanPlayer < Player

  def initialize
    @name = "Human"
  end

  def set_code(test_input = nil)
    puts "To set the code, enter 4 digits between 1 and 6"
    gets.chomp
  end

  def make_guess(guess_number)
    puts "Guess #{guess_number + 1}. Enter 4 digits between 1 and 6:"
    gets.chomp
  end
end
