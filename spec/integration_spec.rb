# spec/integration_spec.rb
require 'spec_helper'
require_relative '../lib/board'
require_relative '../lib/view'

RSpec.describe 'Integration: simple all-piece-types sequence' do
  let(:board) { Board.new }
  let(:view)  { View.new }

  it 'moves N, P, B, R, Q, K at least once (no checks/captures)' do
    board.setup_board

    board.move_piece([7, 6], [5, 5]) # 1) White:  g1 -> f3 (KNIGHT)
    board.move_piece([1, 0], [2, 0]) # 2) Black:  a7 -> a6 (PAWN)
    board.move_piece([6, 4], [5, 4]) # 3) White:  e2 -> e3 (PAWN, frees bishop)
    board.move_piece([0, 0], [1, 0]) # 4) Black:  a8 -> a7 (ROOK)
    board.move_piece([7, 5], [4, 2]) # 5) White:  f1 -> c4 (BISHOP)
    board.move_piece([1, 3], [2, 3]) # 6) Black:  d7 -> d6 (PAWN, frees queen)
    board.move_piece([6, 3], [5, 3]) # 7) White:  d2 -> d3 (PAWN, frees king)
    board.move_piece([0, 3], [1, 3]) # 8) Black:  d8 -> d7 (QUEEN)
    board.move_piece([7, 4], [6, 4]) # 9) White:  e1 -> e2 (KING)

    expected_output = <<~BOARD
      8 _ BN BB _ BK BB BN BR
      7 BR BP BP BQ BP BP BP BP
      6 BP _ _ BP _ _ _ _
      5 _ _ _ _ _ _ _ _
      4 _ _ WB _ _ _ _ _
      3 _ _ _ WP WP WN _ _
      2 WP WP WP _ WK WP WP WP
      1 WR WN WB WQ _ _ _ WR
        a b c d e f g h
    BOARD

    expect { view.show_board(board.grid) }.to output(expected_output).to_stdout
  end
end
