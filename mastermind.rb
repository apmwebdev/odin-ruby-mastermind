class Mastermind
  def initialize
    @code = []
    # @code = [5, 5, 3, 4]
    # @code = [2, 1, 1, 5]
    @guesses_and_matches_log = []
    @game_ui = GameUI.new
    @game_over = false
    create_code
  end

  def play_game
    until @game_over
      render_ui
      get_guess
      check_for_game_over
    end
  end

  private
  
  def create_code(test_input = nil)
    @code = test_input || Array.new(4) { rand(1..6) }
  end

  def render_ui
    @game_ui.render_ui(@guesses_and_matches_log)
  end
  
  def get_guess
    guess_is_valid = false
    until guess_is_valid
      puts 'Enter 4 digits between 1 and 6:'
      user_input = gets.chomp
      if valid_guess?(user_input)
        submit_guess(format_guess(user_input))
        guess_is_valid = true
      end
    end
  end

  def valid_guess?(guess)
    !guess.nil? && guess.length == 4 && !guess.match(/\D|[7-9]|0/)
  end

  def format_guess(guess)
    guess.split('').map(&:to_i)
  end

  def submit_guess(guess)
    p "guess: #{guess}, code: #{@code}"
    matcher = Matcher.new(@code, guess)
    matches = matcher.find_matches
    log_guess_and_matches(guess, matches)
  end
  
  def log_guess_and_matches(guess, matches)
    @guesses_and_matches_log.push({ guess: guess, matches: matches })
  end

  def check_for_game_over
    latest_entry = @guesses_and_matches_log[-1]
    if latest_entry[:matches].all?('exact')
      @game_over = true
      render_ui
      puts "You win! #{latest_entry[:guess]} was the correct answer!"
    elsif @guesses_and_matches_log.length >= 12
      @game_over = true
      render_ui
      puts "You lose. The code was #{@code}"
    end
  end
end

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

class GameUI
  CIRCLE_CHAR = "\u2b24"

  def initialize()
    @padding = 2
    @guess_width = 7
    @matches_width = 11
    @row_divider = ''
    @blank_row = ''
    set_row_divider
    set_blank_row
  end
  
  def render_ui(game_data)
    (system "clear") || (system "cls")
    render_data = []
    game_data.each do |row|
      guess = row[:guess].join(' ')
      matches = format_matches(row[:matches]).join(' ')
      row_output = "|  #{guess}  |  #{matches}  |"
      render_data.push(@row_divider)
      render_data.push(row_output)
    end
    (12 - game_data.length).times do
      render_data.push(@row_divider)
      render_data.push(@blank_row)
    end
    puts add_in_game_instructions_to_render(render_data)
  end

  private

  def set_row_divider
    row_width.times { @row_divider += '-' }
  end

  def set_blank_row
    @blank_row = '|'
    (@guess_width + @padding * 2).times { @blank_row += ' '}
    @blank_row += '|'
    (@matches_width + @padding * 2).times { @blank_row += ' '}
    @blank_row += '|'
  end

  def row_width
    # should be 29
    @padding * 4 + @guess_width + @matches_width + 3
  end

  def add_in_game_instructions_to_render(render_data)
    instructions = []
    instructions.push underline("Instructions:")
    instructions.push "Enter a 4 digit number comprised of digits 1 - 6."
    instructions.push ""
    instructions.push "You will get feedback on your guess in the form of"
    instructions.push "colored circles:"
    instructions.push "  - For every green circle #{green}, that means"
    instructions.push "    you got a digit and the location of that digit"
    instructions.push "    correct."
    instructions.push "  - For every yellow circle #{yellow}, that means"
    instructions.push "    you got a digit correct, but not its"
    instructions.push "    location."
    instructions.push "  - For every red circle #{red}, that means you"
    instructions.push "    guessed a digit that is not part of the"
    instructions.push "    answer, or you guessed a digit too many"
    instructions.push "    times. For example, guessing 1111 when"
    instructions.push "    the answer was 1234 would result in"
    instructions.push "    #{green} #{red} #{red} #{red}"
    instructions.push ""
    instructions.push "Note that the placement of the circles doesn't"
    instructions.push "match up to the placement of digits in your guess."
    instructions.push "Green circles always come first, then yellow, then"
    instructions.push "red."
    # instructions.each do |value|
    #   puts value if value.length > 50
    #   puts value.length
    # end

    render_data.map.with_index { |val, i| "#{val} #{instructions[i]}" }
  end
  
  def format_matches(matches)
    matches.map do |match|
      case match
      when 'none'
        red
      when 'partial'
        yellow
      when 'exact'
        green
      else
        "\u25ef"
      end
    end
  end

  def green(str = nil)
    str = str || CIRCLE_CHAR
    "\e[92m#{str} \e[0m"
  end

  def yellow(str = nil)
    str = str || CIRCLE_CHAR
    "\e[93m#{str} \e[0m"
  end

  def red(str = nil)
    str = str || CIRCLE_CHAR
    "\e[91m#{str} \e[0m"
  end

  def underline(str)
    "\e[4m#{str} \e[24m"
  end

end

game = Mastermind.new
game.play_game
