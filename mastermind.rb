class Mastermind
  def initialize
    @code = {}
    # @code = [1, 2, 3, 4]
    @guess_and_feedback_log = []
    @game_ui = GameUI.new
    @game_over = false
    create_code
    play_game
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
    @game_ui.render_ui(@guess_and_feedback_log)
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
    code_feedback = CodeFeedback.new(@code).container
    # p "code_feedback: #{code_feedback}"
    code_feedback.each do |key, val|
      if guess[key] == val[:numeral]
        # p "Exact match: index: #{key}, value: #{val[:numeral]}"
        val[:hint] = 'black'
      else
        # p "No exact match. Searching for inexact matches..."
        find_inexact_matches(guess, key, code_feedback)
      end
    end
    feedback = code_feedback.map { |_, value| value[:hint] }.sort
    feedback = feedback.sort_by { |str| str == '-----' ? 1 : 0 }
    log_guess_and_feedback(guess, feedback)
  end
  
  def find_inexact_matches(guess, code_key, code_feedback)
    code_item = code_feedback[code_key]
    guess.each do |guess_numeral|
      # p "code_key: #{code_key}, code_item: #{code_item}, guess_numeral: #{guess_numeral}"
      if guess_numeral == code_item[:numeral]
        # p "white match: code numeral = #{code_item[:numeral]}, guess_numeral = #{guess_numeral}"
        code_item[:hint] = 'white'
      end
    end
  end

  def log_guess_and_feedback(guess, feedback)
    @guess_and_feedback_log.push({ guess: guess, feedback: feedback })
  end

  def check_for_game_over
    latest_entry = @guess_and_feedback_log[-1]
    if latest_entry[:feedback].all?('black')
      @game_over = true
      render_ui
      puts "You win! #{latest_entry[:guess]} was the correct answer!"
    elsif @guess_and_feedback_log.length >= 12
      @game_over = true
      render_ui
      puts "You lose. The code was #{@code}"
    end
  end
end

class CodeFeedback
  attr_accessor :container

  def initialize(code_as_array)
    @container = {}
    4.times do |i|
      @container[i] = { numeral: code_as_array[i], hint: '-----' }
    end
  end
end

class GameUI
  def initialize()
    @padding = 2
    @guess_width = 7
    @feedback_width = 23
    @row_divider = ''
    @blank_row = ''
    set_row_divider
    set_blank_row
  end
  
  def render_ui(game_data)
    (system "clear") || (system "cls")
    game_data.each do |row|
      guess = row[:guess].join(' ')
      feedback = row[:feedback].join(' ')
      row_output = "|  #{guess}  |  #{feedback}  |"
      puts @row_divider
      puts row_output
    end
    (12 - game_data.length).times do
      puts @row_divider
      puts @blank_row
    end
  end

  private

  def set_row_divider
    row_width.times { @row_divider += '-' }
  end

  def set_blank_row
    @blank_row = '|'
    (@guess_width + @padding * 2).times { @blank_row += ' '}
    @blank_row += '|'
    (@feedback_width + @padding * 2).times { @blank_row += ' '}
    @blank_row += '|'
  end

  def row_width
    @padding * 4 + @guess_width + @feedback_width + 3
  end
end

mm = Mastermind.new
mm.play_game