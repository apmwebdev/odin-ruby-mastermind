require_relative "matcher"
require_relative "game_ui"

class GameEngine
  def initialize
    @code = []
    # @code = [5, 5, 3, 4]
    # @code = [2, 1, 1, 5]
    @code_setter = nil
    @code_breaker = nil
    @guesses_and_matches_log = []
    @game_ui = GameUI.new
    @game_over = false
  end

  def play
    show_intro
  end

  private

  def show_intro
    @game_ui.show_intro_1
    puts " Enter 1 to see an example or 0 to play now"
    answer_1 = gets.chomp
    if answer_1 == "1" || answer_1 == ""
      @game_ui.show_intro_2
      puts " Press Enter to continue"
      gets.chomp
      choose_mode
    elsif answer_1 == "0"
      choose_mode
    else
      show_intro
    end
  end

  def choose_mode
    @game_ui.show_choose_mode
    answer = gets.chomp
    if answer == "1"
      play_as_code_breaker
    elsif answer == "2"
      play_as_code_setter
    elsif answer == "3"
      show_intro
    else
      choose_mode
    end
  end

  def play_as_code_breaker
    @code_breaker = HumanPlayer.new
    @code_setter = ComputerPlayer.new
    do_main_play_sequence
  end

  def play_as_code_setter
    @code_setter = HumanPlayer.new
    @code_breaker = ComputerPlayer.new
    do_main_play_sequence
  end

  def do_main_play_sequence
    set_code
    until @game_over
      render_ui
      get_guess
      check_for_game_over
    end
    maybe_play_again
  end

  def maybe_play_again
    reset_game
    @game_ui.show_play_again
    answer = gets.chomp
    case answer
    when "1"
      play_as_code_breaker
    when "2"
      play_as_code_setter
    when "3"
      show_intro
    end
  end

  def reset_game
    @game_over = false
    @guesses_and_matches_log = []
  end

  def set_code
    code_is_valid = false
    until code_is_valid
      user_input = @code_setter.set_code
      if valid_code_or_guess?(user_input)
        @code = format_code_or_guess(user_input)
        code_is_valid = true
      end
    end
  end

  def render_ui
    @game_ui.render_ui(@guesses_and_matches_log)
  end
  
  def get_guess
    guess_is_valid = false
    until guess_is_valid
      user_input = @code_breaker.make_guess
      if valid_code_or_guess?(user_input)
        submit_guess(format_code_or_guess(user_input))
        guess_is_valid = true
      end
    end
  end

  def valid_code_or_guess?(guess)
    !guess.nil? && guess.length == 4 && !guess.match(/\D|[7-9]|0/)
  end

  def format_code_or_guess(guess)
    guess.chars.map(&:to_i)
  end

  def submit_guess(guess)
    p "guess: #{guess}, code: #{@code}"
    matcher = Matcher.new(@code, guess)
    matches = matcher.find_matches
    log_guess_and_matches(guess, matches)
  end
  
  def log_guess_and_matches(guess, matches)
    @guesses_and_matches_log.push({guess: guess, matches: matches})
    if @code_breaker.is_a? ComputerPlayer
      @code_breaker.guesses_and_matches_log = @guesses_and_matches_log
    end
  end

  def check_for_game_over
    latest_entry = @guesses_and_matches_log[-1]
    if latest_entry[:matches].all?("exact")
      @game_over = true
      render_ui
      puts "#{@code_breaker.name} wins! #{latest_entry[:guess]} was the correct answer!"
    elsif @guesses_and_matches_log.length >= 12
      @game_over = true
      render_ui
      puts "#{@code_setter.name} wins! The code was #{@code}"
    end
  end
end