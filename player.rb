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
end
