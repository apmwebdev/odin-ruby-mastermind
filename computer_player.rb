require_relative "matcher"

class ComputerPlayer < Player
  attr_accessor :guesses_and_matches_log

  def initialize
    @name = "Computer"
    @guesses_and_matches_log = []
    @codes = []
  end

  def set_code(test_input = nil)
    test_input || Array.new(4) { rand(1..6) }
  end

  def make_guess
    if @codes.empty?
      codes = (1111..6666).to_a
      codes = codes.map { |item| item.to_s }
      codes.reject { |item| item.match(/[7-9]|0/) }
      @codes = codes.map { |item| format_code_or_guess(item) }
    end
    return format_code_or_guess("1122") if @guesses_and_matches_log.empty?
    determine_guess
  end

  def determine_guess
    eliminate_codes
    codes_prime = @codes.map(&:clone)
    guess_table = {}
    maxed_guesses = {}
    @codes.each do |code|
      guess_table[code] = Hash.new(0)
      codes_prime.each do |code_prime|
        result = Matcher.new(
          code_prime,
          code
        ).find_matches.join(" ")
        guess_table[code][result] += 1
      end
      maxed_guesses[code] = guess_table[code].values.max
    end
    format_code_or_guess(maxed_guesses.key(maxed_guesses.values.min))
  end

  def eliminate_codes
    latest_match = @guesses_and_matches_log.last[:matches]
    latest_guess = @guesses_and_matches_log.last[:guess]
    codes_to_remove = []
    @codes.each do |code|
      matches = Matcher.new(
        latest_guess,
        code
      ).find_matches
      if matches != latest_match
        codes_to_remove.push(code)
      end
    end
    codes_to_remove.each { |code| @codes.delete(code) }
  end
end
