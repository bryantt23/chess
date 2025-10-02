# lib/parser.rb
class Parser
  # Converts "e2" into [row, col] indices
  def self.coord_to_index(coord)
    file, rank = coord.chars
    col = file.ord - 'a'.ord        # 'a' → 0, 'b' → 1 … 'h' → 7
    row = 8 - rank.to_i             # '8' → 0, '1' → 7
    [row, col]
  end

  # Converts "e2 e4" into [[row1,col1], [row2,col2]]
  def self.parse_move(input)
    from, to = input.strip.split(" ")
    [coord_to_index(from), coord_to_index(to)]
  end
end
