class ComputerPlayer < Player

  def initialize
    @name = "Computer"
    @codes = [1111..6666]
    @guesses_and_matches_log = []
  end

  def set_code(test_input = nil)
    test_input || Array.new(4) { rand(1..6) }.join("")
  end

  def make_guess
    determine_guess
  end

  def determine_guess
    "1111"
  end
end
