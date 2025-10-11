class View
  def welcome
    puts 'Welcome to Chess!'
  end

  def show_turn(player)
    puts "#{player.capitalize} to move. Enter your move:"
  end

  def show_board(grid)
    row_num = 8
    grid.each do |row|
      puts "#{row_num} #{row.map { |elem| elem.nil? ? '__' : elem.display }.join(' ')}"
      row_num -= 1
    end
    puts ['', 'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h'].join('  ')
  end

  def illegal_move
    puts 'Invalid move. Try again.'
  end

  def invalid_format
    puts "Invalid format. Please use moves like 'e2 e4'."
  end

  def in_check(player)
    puts "#{player.capitalize} is in check!"
  end

  def checkmate(player)
    puts "Checkmate! #{player.capitalize} loses."
  end  

  def invalid_selection
    "Invalid selection"
  end
  
  def show_new_game_saved_games(saved_games)
    if saved_games.empty?
      puts "(N)ew game (no saved games available) or (X) to exit"
    else
      lines = ["(N)ew game or choose a saved game, or (X) to exit"]
      saved_games.each_with_index do |filename, index|
        lines << "#{index + 1}. #{filename}"
      end
      puts lines.join("\n")
    end
  end
end
