class View
  def welcome
    puts 'Welcome to Chess!'
  end

  def show_turn(player)
    puts "It is #{player}'s turn"
  end

  def show_board(grid)
    row_num=8
    grid.each do |row| 
      puts "#{row_num} #{(row.map { |elem| elem==nil ? "_": elem.display }).join(" ")}"
      row_num-=1
    end
    puts [' ', 'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h'].join(' ')
  end
end
