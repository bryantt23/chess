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
end
