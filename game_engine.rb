require_relative 'matcher.rb'
require_relative 'game_ui'

class GameEngine
  def initialize
    @code = []
    # @code = [5, 5, 3, 4]
    # @code = [2, 1, 1, 5]
    @guesses_and_matches_log = []
    @game_ui = GameUI.new
    @game_over = false
  end

  def play_game
    show_intro
    # until @game_over
    #   render_ui
    #   get_guess
    #   check_for_game_over
    # end
  end

  private

  def show_intro
    @game_ui.show_intro_1
    puts "Press esc to skip intro or space to see next screen"
    answer_1 = gets.chomp
    @game_ui.show_intro_2
  end
  
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