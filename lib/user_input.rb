class UserInput
  def self.valid_input?(input)
    # Normalize whitespace: collapse multiple spaces, strip leading/trailing
    input = input.strip.gsub(/\s+/, ' ')
    arr = input.split(' ')

    if arr.length != 2
      false
    else
      # Regex explanation:
      # \A and \z  → match the entire string (anchors)
      # ([a-h][1-8]) → one square: a-h file + 1-8 rank (case-insensitive)
      # \s → single space between from/to
      # ([a-h][1-8]) → second square
      !!(input =~ /\A([a-h][1-8])\s([a-h][1-8])\z/i)
    end
  end
end
