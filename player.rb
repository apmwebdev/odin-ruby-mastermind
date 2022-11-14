class Player
  attr_reader :name

  def initialize
    @name = "[Name]"
  end

  def set_code
    raise "Not implemented"
  end

  def make_guess
    raise "Not implemented"
  end

  def valid_code_or_guess?(guess)
    !guess.nil? && guess.length == 4 && !guess.match(/\D|[7-9]|0/)
  end

  def format_code_or_guess(guess)
    guess.chars.map(&:to_i)
  end

end
