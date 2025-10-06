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
    if parsed_move == :invalid_format
      @view.invalid_format
    else
      result = @board.move_piece(parsed_move[0], parsed_move[1])

      if result == :illegal
        @view.illegal_move
      else
        # puts other player in check?
        other_player = @current_turn == :white ? :black : :white
        in_check = @board.is_check?(other_player)

        @view.in_check(other_player) if in_check

        @current_turn = @current_turn == :white ? :black : :white
      end
    end
    play_turn
  end

  def get_input
    $stdin.gets&.chomp
  end
end
