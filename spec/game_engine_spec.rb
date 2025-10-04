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
end
