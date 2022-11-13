class Matcher
  attr_reader :code, :guess

  def initialize(input_code = nil, input_guess = nil)
    @code = {}
    if input_code
      set_code(input_code)
    end

    @guess = {}
    if input_guess
      set_guess(input_guess)
    end

    @exact_matches = 0
    @partial_matches = 0
    @no_matches = 0
  end

  def set_code(input)
    if input.is_a? String
      code = input.chars.map(&:to_i)
    elsif input.is_a? Array
      code = input
    else
      raise "Error: Input code must be string or array"
    end
    code.each_with_index do |item, index|
      @code[index] = {numeral: item, matched: false}
    end
  end

  def code=(input)
    set_code(input)
  end

  def set_guess(input)
    if input.is_a? String
      guess = input.chars.map(&:to_i)
    elsif input.is_a? Array
      guess = input
    else
      raise "Error: Input guess must be string or array"
    end
    guess.each_with_index do |item, index|
      @guess[index] = {numeral: item, matched: false}
    end
  end

  def guess=(input)
    set_guess(input)
  end

  def reset_code_matched_flags
    @code.each { |_, value| value[:matched] = false }
  end

  def reset_guess_matched_flags
    @guess.each { |_, value| value[:matched] = false }
  end

  def reset
    reset_code_matched_flags
    reset_guess_matched_flags
    @exact_matches = 0
    @partial_matches = 0
    @no_matches = 0
  end

  def find_matches
    if @code.empty? || @guess.empty?
      raise "Code or Guess is empty. Can't find matches"
    else
      find_exact_matches
      find_partial_matches
      return_matches
    end
  end

  private

  def find_exact_matches
    @code.each do |key, value|
      if value[:matched] == true
        next
      end
      if value[:numeral] == @guess[key][:numeral] && !@guess[key][:matched]
        @exact_matches += 1
        value[:matched] = true
        @guess[key][:matched] = true
      end
    end
  end

  def find_partial_matches
    @code.each do |code_key, code_value|
      if code_value[:matched] == true
        next
      end
      @guess.each do |guess_key, guess_value|
        if guess_value[:matched] == true
          next
        end
        if code_value[:numeral] == guess_value[:numeral]
          @partial_matches += 1
          code_value[:matched] = true
          guess_value[:matched] = true
          break
        end
      end
      next
    end
  end

  def return_matches
    return_array = []
    if @exact_matches + @partial_matches > 4
      puts "something went wrong while assessing guess"
      4.times { return_array.push "ERROR" }
    else
      @no_matches = 4 - (@exact_matches + @partial_matches)
      @exact_matches.times { return_array.push("exact") }
      @partial_matches.times { return_array.push("partial") }
      @no_matches.times{ return_array.push("none") }
    end
    return_array
  end
end
