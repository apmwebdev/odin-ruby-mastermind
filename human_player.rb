class HumanPlayer < Player
  attr_reader :current_guess, :code

  def initialize
    @name = "Human"
    @current_guess = nil
    @code = nil
  end

  def set_code(test_input = nil)
    code_is_valid = false
    until code_is_valid
      puts "To set the code, enter 4 digits between 1 and 6"
      user_input = gets.chomp
      if valid_code_or_guess?(user_input)
        code_is_valid = true
      end
    end
    result = format_code_or_guess(user_input)
    @code = result
  end

  def make_guess(guess_number)
    guess_is_valid = false
    user_input = nil
    until guess_is_valid
      puts "Guess #{guess_number + 1}/12. Enter 4 digits between 1 and 6:"
      user_input = gets.chomp
      if valid_code_or_guess?(user_input)
        guess_is_valid = true
      end
    end
    result = format_code_or_guess(user_input)
    p "make_guess result = #{result}"
    @current_guess = result
  end
end
