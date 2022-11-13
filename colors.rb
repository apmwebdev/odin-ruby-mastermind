def unicode(char_string)
  if char_string.is_a? String
    puts "\e[92m#{char_string} \e[0m"
  elsif char_string.is_a? Array
    char_string.each do |item|
      puts "\e[91m#{item} \e[0m"
    end
  end
end
green_circle = "\e[92m\u2b24 \e[0m"

def create_symbols(input)
  arr = input.split
  arr2 = arr.map do |item|
    hex = "0x#{item}".to_i(16)
    hex.chr('UTF-8')
  end
  arr2
end

symbol_str = '2b24 29bb 2205 2b55 2b1a 2b1b 2b1c 25ef 2588 2591 2592 2593'

unicode(create_symbols(symbol_str))