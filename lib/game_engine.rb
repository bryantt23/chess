require_relative 'user_input'
require_relative 'board'
require_relative 'parser'
require_relative 'view'

class GameEngine
  attr_reader :current_turn

  def initialize(board, view)
    @view = view
    @board = board
  end

  def new_game
    @current_turn = :white
    @view.welcome
    @board.setup_board
    play_turn
  end

  def play_turn
    @view.show_board(@board.grid)
    @view.show_turn(@current_turn)
    player_move = get_input
    return nil if player_move.nil? || player_move.strip.downcase == 'exit'

    move(player_move)
  end

  def move(player_move)
    parsed_move = Parser.parse_move(player_move)
    @board.move_piece(parsed_move[0], parsed_move[1])
    @current_turn = @current_turn == :white ? :black : :white
    play_turn
  end

  def get_input
    $stdin.gets&.chomp
  end
end

# board = Board.new
# view = View.new
# engine = GameEngine.new(board, view)
# engine.new_game
