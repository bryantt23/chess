class View
  def welcome
    puts 'Welcome to Chess!'
  end

  def show_turn(player)
    puts "It is #{player}'s turn"
  end

  def show_board
    8.downto(1) do |row|
      puts "#{row} #{Array.new(8, '_').join(' ')}"
    end
    puts [' ', 'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h'].join(' ')
  end
end
