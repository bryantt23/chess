require 'spec_helper'
require_relative '../lib/board'
require_relative '../lib/game_engine'
require_relative '../lib/view'
require 'stringio'

RSpec.describe GameEngine do
  let(:board) { Board.new }
  let(:view)  { View.new }
  let(:engine) { GameEngine.new(board, view) }

  after { $stdin = STDIN } # always restore stdin after each test

  # 1️⃣ WELCOME — NO MOVES
  describe '#new_game' do
    it 'shows welcome and initial board with White to move' do
      $stdin = StringIO.new("exit\n")

      expect { engine.new_game }.to output(
        <<~BOARD
          Welcome to Chess!
          8 BR BN BB BQ BK BB BN BR
          7 BP BP BP BP BP BP BP BP
          6 __ __ __ __ __ __ __ __
          5 __ __ __ __ __ __ __ __
          4 __ __ __ __ __ __ __ __
          3 __ __ __ __ __ __ __ __
          2 WP WP WP WP WP WP WP WP
          1 WR WN WB WQ WK WB WN WR
            a  b  c  d  e  f  g  h
          White to move. Enter your move:
        BOARD
      ).to_stdout
    end
  end

  # 2️⃣ ONE WHITE MOVE
  describe '#new_game' do
    it 'shows final board after White moves e2 e4 and stops' do
      $stdin = StringIO.new("e2 e4\nexit\n")

      expected_final_output = <<~BOARD
        8 BR BN BB BQ BK BB BN BR
        7 BP BP BP BP BP BP BP BP
        6 __ __ __ __ __ __ __ __
        5 __ __ __ __ __ __ __ __
        4 __ __ __ __ WP __ __ __
        3 __ __ __ __ __ __ __ __
        2 WP WP WP WP __ WP WP WP
        1 WR WN WB WQ WK WB WN WR
          a  b  c  d  e  f  g  h
        Black to move. Enter your move:
      BOARD

      output = capture_stdout { engine.new_game }

      # The output should contain the final expected board (in the end)
      expect(output).to include(expected_final_output)
      expect(output).to end_with("Black to move. Enter your move:\n")
    end
  end

  # 3️⃣ WHITE + BLACK ROUND
  describe '#play_turn' do
    it 'shows final board after White (e2 e4) then Black (e7 e5)' do
      # First move: White
      $stdin = StringIO.new("e2 e4\n")
      engine.new_game

      # Second move: Black, then exit
      $stdin = StringIO.new("e7 e5\nexit\n")

      expected_final_output = <<~BOARD
        8 BR BN BB BQ BK BB BN BR
        7 BP BP BP BP __ BP BP BP
        6 __ __ __ __ __ __ __ __
        5 __ __ __ __ BP __ __ __
        4 __ __ __ __ WP __ __ __
        3 __ __ __ __ __ __ __ __
        2 WP WP WP WP __ WP WP WP
        1 WR WN WB WQ WK WB WN WR
          a  b  c  d  e  f  g  h
        White to move. Enter your move:
      BOARD

      output = capture_stdout { engine.play_turn }

      expect(output).to include(expected_final_output)
      expect(output).to end_with("White to move. Enter your move:\n")
    end
  end

  # 4️⃣ INVALID WHITE MOVE
  describe '#new_game' do
    it 'shows error and re-prompts when White makes an invalid first move' do
      # White tries illegal move then exits
      $stdin = StringIO.new("e2 e5\nexit\n")

      expect { engine.new_game }.to output(
        a_string_including(
          'White to move. Enter your move:',
          'Invalid move. Try again.',
          'White to move. Enter your move:'
        )
      ).to_stdout
    end
  end

  # 5️⃣ INVALID FORMAT (BAD INPUT)
  describe '#new_game' do
    it 'shows format error when White enters badly formatted move' do
      # White types nonsense, then exits
      $stdin = StringIO.new("hello\nexit\n")

      expect { engine.new_game }.to output(
        a_string_including(
          'White to move. Enter your move:',
          "Invalid format. Please use moves like 'e2 e4'.",
          'White to move. Enter your move:'
        )
      ).to_stdout
    end
  end

  # 6️⃣ WHITE PAWN CAPTURES BLACK PAWN
  describe '#new_game' do
    it 'shows correct final board after White Pawn captures Black Pawn' do
      # Sequence: White pawn forward, Black pawn forward, White captures
      $stdin = StringIO.new("e2 e4\nd7 d5\ne4 d5\nexit\n")

      expected_final_output = <<~BOARD
        8 BR BN BB BQ BK BB BN BR
        7 BP BP BP __ BP BP BP BP
        6 __ __ __ __ __ __ __ __
        5 __ __ __ WP __ __ __ __
        4 __ __ __ __ __ __ __ __
        3 __ __ __ __ __ __ __ __
        2 WP WP WP WP __ WP WP WP
        1 WR WN WB WQ WK WB WN WR
          a  b  c  d  e  f  g  h
        Black to move. Enter your move:
      BOARD

      output = capture_stdout { engine.new_game }

      expect(output).to end_with(expected_final_output)
    end
  end

  # 7️⃣ CHECK MESSAGE
  describe '#new_game' do
    xit 'shows "White is in check!" when Black moves into check position' do
      # Moves: White opens f-pawn, Black opens e-pawn, White weakens defense, Black queen moves to h4 -> check
      $stdin = StringIO.new("f2 f3\ne7 e5\ng2 g4\nd8 h4\nexit\n")

      output = capture_stdout { engine.new_game }

      expect(output).to include('White is in check!')
      expect(output).to end_with("White to move. Enter your move:\n")
    end
  end

  describe '#load_custom_board' do
    it 'prints the welcome message and correct simple board when loading custom position' do
      # Arrange
      custom_grid = Array.new(8) { Array.new(8) }
      custom_grid[7][4] = King.new(:white) # e1
      custom_grid[0][0] = Rook.new(:black) # a8

      board.set_grid(custom_grid)
      $stdin = StringIO.new("exit\n")

      # Act + Assert
      expect { engine.new_game }.to output(
        a_string_including(
          'Welcome to Chess!',
          '8 BR __ __ __ __ __ __ __',
          '1 __ __ __ __ WK __ __ __',
          'White to move. Enter your move:'
        )
      ).to_stdout
    end
  end
end
