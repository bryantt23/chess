require_relative 'user_input'
require_relative 'board'
require_relative 'parser'
require_relative 'view'
require_relative 'save_manager'

class GameEngine
  attr_reader :current_turn

  SAVE_DIR = File.join(__dir__, '..', 'saves')

  def initialize(board, view)
    @view = view
    @board = board
    @game_over = false
  end

  def new_game
    @current_turn = :white
    @view.welcome
    play_turn
  end

  def valid_selection?(input, filenames)
    return false unless input.match?(/^\d+$/) # digits only

    index = input.to_i
    index >= 1 && index <= filenames.length
  end

  def welcome
    @view.welcome
    loop do
      filenames = Dir.children(SAVE_DIR)
      @view.show_new_game_saved_games(filenames)
      input = gets.chomp
      if input.downcase == 'n'
        new_game
      elsif input.downcase == 'x'
        puts 'Goodbye!'
        exit
      elsif valid_selection?(input, filenames)
        file_to_load = filenames[input.to_i - 1]
        game_state_hash = SaveManager.load_game("#{SAVE_DIR}/#{file_to_load}")
        @current_turn = game_state_hash[:current_turn] == 'white' ? :white : :black
        @board = Board.from_hash(game_state_hash[:grid])
        play_turn
        exit
      else
        puts @view.invalid_selection
      end
    end
  end

  def play_turn
    @view.show_board(@board.grid)
    @view.show_turn(@current_turn)
    player_move = get_input

    return nil if player_move.nil? || player_move.strip.downcase == 'exit'

    if player_move.strip.downcase == 'save'
      Dir.mkdir(SAVE_DIR) unless Dir.exist?(SAVE_DIR)
      file_path = File.join(SAVE_DIR, "#{Time.now.strftime('%Y-%m-%d-%H-%M-%S')}.json")
      game_state = {
        grid: @board.grid,
        current_turn: @current_turn
      }
      SaveManager.save_game(game_state, file_path)
      return
    end

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
        if in_check
          checkmate = @board.checkmate?(other_player)
          if checkmate
            @view.checkmate(other_player)
            @view.show_board(@board.grid)
            @game_over = true
          else
            @view.in_check(other_player)
          end
        end

        @current_turn = @current_turn == :white ? :black : :white
      end
    end

    return if @game_over == true

    play_turn
  end

  def get_input
    $stdin.gets&.chomp
  end
end

# board = Board.new
# view = View.new
# game = GameEngine.new(board, view)
# game.welcome
