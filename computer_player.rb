require_relative "matcher"

class ComputerPlayer < Player
  attr_accessor :guesses_and_matches_log

  def initialize
    @name = "Computer"
    @guesses_and_matches_log = []
    @codes = []
    @matcher = nil
  end

  def set_code(test_input = nil)
    test_input || Array.new(4) { rand(1..6) }.join("")
  end

  def make_guess
    sleep(0.2)
    if @codes.empty?
      codes = (1111..6666).to_a
      codes = codes.map { |item| item.to_s }
      @codes = codes.reject { |item| item.match(/[7-9]|0/) }
      p @codes
    end
    return "1122" if @guesses_and_matches_log.empty?
    determine_guess
  end

  def determine_guess
    eliminate_codes
    codes_prime = @codes.map(&:clone)
    @matcher ||= Matcher.new
    guess_table = {}
    maxed_guesses = {}
    @codes.each do |code|
      guess_table[code] = Hash.new(0)
      @matcher.guess = code
      codes_prime.each do |code_prime|
        @matcher.code = code_prime
        result = @matcher.find_matches.join(" ")
        guess_table[code][result] += 1
        @matcher.reset
      end
      maxed_guesses[code] = guess_table[code].values.max
    end
    maxed_guesses.key(maxed_guesses.values.min)
  end

  def eliminate_codes
    latest_match = @guesses_and_matches_log.last[:matches]
    latest_guess = @guesses_and_matches_log.last[:guess]
    @matcher ||= Matcher.new
    @matcher.code = latest_guess
    codes_to_remove = []
    @codes.each do |code|
      @matcher.guess = code
      result = @matcher.find_matches
      if result != latest_match
        codes_to_remove.push(code)
      end
      @matcher.reset
    end
    codes_to_remove.each { |code| @codes.delete(code)}
  end
end

# comp = ComputerPlayer.new
# comp.guesses_and_matches_log = [{guess: [1, 1, 2, 2], matches: ['exact', 'partial', 'none', 'none']}]
# comp.make_guess