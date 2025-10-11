require "json"

class SaveManager
  def self.save_game(game_state, file)
    data={
      grid: serialize_grid(game_state[:grid]),
      current_turn: game_state[:current_turn]
    }
    json_string = data.to_json
    File.open(file, "w") do |f|
      f.write(json_string)
    end
  end

  def self.serialize_grid(grid)
    grid.map do |row|
      row.map do |piece|
        if piece.nil?
          nil
        else
          { type:piece.class.to_s, color: piece.color }
        end
      end
    end
  end

  def self.load_game(file)
    content = File.read(file)
    data = JSON.parse(content, symbolize_names: true)

    # Normalize status back to a symbol
    if data[:status].is_a?(String)
      data[:status] = data[:status].to_sym
    end
    data
  end
end
