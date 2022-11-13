class Matcher
  attr_accessor :container

  def initialize(input_code, input_guess)
    p "Matcher class"
    @code = {}
    input_code.each_with_index do |item, index|
      @code[index] = {numeral: item, matched: false}
    end
    # p "@code = #{@code}"

    @guess = {}
    input_guess.each_with_index do |item, index|
      @guess[index] = {numeral: item, matched: false}
    end
    # p "@guess = #{@guess}"

    @exact_matches = 0
    @partial_matches = 0
    @no_matches = 0
  end

  def find_matches
    find_exact_matches
    find_partial_matches
    return_matches
  end

  private

  def find_exact_matches
    # p "find_exact_matches"
    @code.each do |key, value|
      # p "key = #{key}, value=#{value}"
      if value[:matched] == true
        # p "already matched"
        next
      end
      if value[:numeral] == @guess[key][:numeral] && !@guess[key][:matched]
        # p "exact match: #{value[:numeral]} == #{@guess[key][:numeral]}, guess item is not matched yet: #{@guess[key][:matched]}"
        @exact_matches += 1
        # p "@exact_matches increased by 1, now equal to #{@exact_matches}"
        value[:matched] = true
        @guess[key][:matched] = true
        # p "Both elements should now have matched = true: @code: #{@code}, @guess: #{@guess}"
      end
    end
  end

  def find_partial_matches
    # p "find_partial_matches"
    @code.each do |code_key, code_value|
      # p "code_key: #{code_key}, code_value: #{code_value}"
      if code_value[:matched] == true
        # p "code element already matched"
        next
      end
      @guess.each do |guess_key, guess_value|
        # p "guess_key: #{guess_key}, guess_value: #{guess_value}"
        if guess_value[:matched] == true
          # p "guess element already matched"
          next
        end
        if code_value[:numeral] == guess_value[:numeral]
          # p "partial match. #{code_value[:numeral]} == #{guess_value[:numeral]}"
          @partial_matches += 1
          # p "@partial_matches increased by 1, now equal to #{@partial_matches}"
          code_value[:matched] = true
          guess_value[:matched] = true
          # p "Both elements should now have matched = true: @code: #{@code}, @guess: #{@guess}"
          break
        end
      end
      next
    end
  end

  def return_matches
    p "return_matches: @exact_matches = #{@exact_matches}, @partial_matches = #{@partial_matches}"
    return_array = []
    if @exact_matches + @partial_matches > 4
      puts "something went wrong while assessing guess"
      4.times { return_array.push"ERROR" }
    else
      @no_matches = 4 - (@exact_matches + @partial_matches)
      @exact_matches.times { return_array.push("exact") }
      @partial_matches.times { return_array.push("partial") }
      @no_matches.times{ return_array.push("none") }
    end
    return_array
  end
end
