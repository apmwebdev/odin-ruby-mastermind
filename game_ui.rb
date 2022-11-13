
class GameUI
  CIRCLE_CHAR = "\u2b24"

  def initialize
    @padding = 2
    @guess_width = 7
    @matches_width = 11
    @row_divider = ''
    @blank_row = ''
    set_row_divider
    set_blank_row
  end

  def show_intro_1
    txt = <<-intro_text
#{"MASTERMIND".underline.blue}
Mastermind is a logic game played between two players. One player comes up 
with a secret code, and the other player tries to guess it.

In this version of the game, the secret code consists of a #{'4 digit number'.bold.yellow}, 
where the individual digits of the number can be between 1 and 6, and repeats 
#{'are'.italic} allowed.

Examples: #{' 1234 '.invert_color.yellow}, #{' 6543 '.invert_color.yellow}, and #{' 1111 '.invert_color.yellow} are all valid codes.

The guesser has a certain number of tries (12 by default) to 
break the code. With each guess, the guesser gets feedback in the form of 4 
colored circles that will be some combination of #{'green'.green} #{green}, #{'yellow'.yellow} #{yellow}, and #{'red'.red} #{red}.

 #{green}: Each green circle represents one digit in the guess where the 
number as well as the location of the number were both correct.
 #{yellow}: Each yellow circle represents one digit in the guess where the 
number was correct, but it was in the wrong place.
 #{red}: Each red circle represents one digit in the guess that doesn't show 
up in the secret code (or shows up in the secret code fewer times than the 
number of times you guessed that number).
intro_text
    clear_screen
    puts txt
  end

  def show_intro_2
    clear_screen
    puts "placeholder text"
  end

  def render_ui(game_data)
    clear_screen
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

  def clear_screen
    (system "clear") || (system "cls")
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
