
class GameUI
  CIRCLE_CHAR = "\u2b24"

  def initialize
    @padding = 2
    @guess_width = 7
    @matches_width = 11
    @row_divider = ""
    @blank_row = ""
    set_row_divider
    set_blank_row
  end

  def show_intro_1
    txt = <<-INTRO_TEXT

  #{"MASTERMIND".bold.underline.cyan}

 Mastermind is a logic game played between two players. The #{code_setter} comes up
 with a secret code, and the #{code_breaker} tries to guess it.

 In this version of the game, the secret code consists of a #{"4 digit number".bold.yellow}, 
 where the individual digits of the number can be between #{"1".green.bold} and #{"6".green.bold}, and repeats 
 #{"are".italic.bold} allowed. For example, #{" 1234 ".inv}, #{" 6544 ".inv}, and #{" 1111 ".inv} are all valid codes.

 The #{code_breaker} has a certain number of tries (#{"12".red.bold} by default) to break the
 code. With each guess, the code breaker gets feedback in the form of 4 colored
 circles that will be some combination of #{"green".green} #{green}, #{"yellow".yellow} #{yellow}, and #{"red".red} #{red}

  #{green}: Each #{"green".green.bold} circle represents one digit in the guess where the #{"number".bold} as
      well as the #{"location".bold} of the number are both correct.

  #{yellow}: Each #{"yellow".yellow.bold} circle represents one digit in the guess where the #{"number".bold} is
      correct, but the #{"location".bold} is incorrect.

  #{red}: Each #{"red".red.bold} circle represents one digit in the guess that doesn't show up
      in the secret code (or shows up in the secret code fewer times than the
      number of times you guessed that number).

 You can choose to be either the #{code_breaker} or the #{code_setter}, and the
 computer will play the other role.


    INTRO_TEXT
    clear_screen
    puts txt
  end

  def show_intro_2
    txt = <<-INTRO_TEXT_2

  #{"MASTERMIND".bold.underline.cyan}
    
    #{"EXAMPLE:".bold.blue} Code is #{" 1234 ".inv}
 #{@row_divider}
 |   #{"GUESS".bold}   |    #{"FEEDBACK".bold}   |     The first #{" 1 ".inv} is in the right place (#{green}) and
 #{@row_divider}     the first one of the #{" 2 ".inv}s gets counted (#{yellow}).
 |  1 1 2 2  |  #{green} #{yellow} #{red} #{red}  | <-- The second #{" 1 ".inv} and #{" 2 ".inv} get marked as #{red}.
 #{@row_divider}
 |  3 4 5 6  |  #{yellow} #{yellow} #{red} #{red}  | <-- The #{" 3 ".inv} and #{" 4 ".inv} are both present, but in the
 #{@row_divider}     wrong place, so they're both #{yellow}. #{" 5 ".inv} and #{" 6 ".inv}
 |  2 1 3 4  |  #{green} #{green} #{yellow} #{yellow}  |     don't show up in the code at all, so they 
 #{@row_divider}     result in 2 #{red}.
 |  1 2 3 4  |  #{green} #{green} #{green} #{green}  | <-- WIN!
 #{@row_divider}

 As shown in the first guess above, you'll only get as many #{green} and/or #{yellow} for a
 given number for:

   a) however many times it shows up in the code, or
   b) however many times it shows up in your guess,

 whichever is lower.

 Also, note that the placement of the colored circles is determined by their
 color, not by which digit in the guess or code they correspond to. Going left
 to right, green is always first, then yellow, then red.

 OK, let's play!


    INTRO_TEXT_2
    clear_screen
    puts txt
  end

  def show_choose_mode
    txt = <<-CHOOSE_MODE_TEXT

  #{"MASTERMIND".bold.underline.cyan}

 #{"Choose mode:".bold}

 Press #{"1".red.bold} to be the #{"CODE BREAKER".red.bold}

 Press #{"2".green.bold} to be the #{"CODE SETTER".green.bold}

 Press #{"3".blue.bold} to go back to the #{"INSTRUCTIONS".blue.bold}


    CHOOSE_MODE_TEXT
    clear_screen
    puts txt
  end

  def code_breaker
    "code breaker".upcase.bold.red
  end

  def code_setter
    "code setter".upcase.bold.green
  end

  def render_ui(game_data)
    clear_screen
    render_data = []
    game_data.each do |row|
      guess = row[:guess].join(" ")
      matches = format_matches(row[:matches]).join(" ")
      row_output = "|  #{guess}  |  #{matches}  |"
      render_data.push(@row_divider)
      render_data.push(row_output)
    end
    (12 - game_data.length).times do
      render_data.push(@row_divider)
      render_data.push(@blank_row)
    end
    render_data.push(@row_divider)
    puts add_in_game_instructions_to_render(render_data)
  end

  private

  def set_row_divider
    row_width.times { @row_divider += "-" }
  end

  def set_blank_row
    @blank_row = "|"
    (@guess_width + @padding * 2).times { @blank_row += " "}
    @blank_row += "|"
    (@matches_width + @padding * 2).times { @blank_row += " "}
    @blank_row += "|"
  end

  def row_width
    # should be 29
    @padding * 4 + @guess_width + @matches_width + 3
  end

  def add_in_game_instructions_to_render(render_data)
    instructions = []
    instructions.push underline("Reminder:")
    instructions.push "Enter a 4 digit number comprised of digits 1 - 6."
    instructions.push ""
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

    render_data.map.with_index { |val, i| "#{val} #{instructions[i]}" }
  end

  def clear_screen
    (system "clear") || (system "cls")
  end

  def format_matches(matches)
    matches.map do |match|
      case match
      when "none"
        red
      when "partial"
        yellow
      when "exact"
        green
      else
        "\u25ef"
      end
    end
  end

  def green(str = nil)
    str ||= CIRCLE_CHAR
    "\e[92m#{str} \e[0m"
  end

  def yellow(str = nil)
    str ||= CIRCLE_CHAR
    "\e[93m#{str} \e[0m"
  end

  def red(str = nil)
    str ||= CIRCLE_CHAR
    "\e[91m#{str} \e[0m"
  end

  def underline(str)
    "\e[4m#{str} \e[24m"
  end
end
