class HumanPlayer < Player

  def initialize
    @name = "Human"
  end

  def set_code(test_input = nil)
    puts "To set the code, enter 4 digits between 1 and 6"
    gets.chomp
  end

  def make_guess
    puts "Enter 4 digits between 1 and 6:"
    gets.chomp
  end
end
