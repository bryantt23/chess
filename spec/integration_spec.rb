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
      8 __ BN BB __ BK BB BN BR
      7 BR BP BP BQ BP BP BP BP
      6 BP __ __ BP __ __ __ __
      5 __ __ __ __ __ __ __ __
      4 __ __ WB __ __ __ __ __
      3 __ __ __ WP WP WN __ __
      2 WP WP WP __ WK WP WP WP
      1 WR WN WB WQ __ __ __ WR
        a b c d e f g h
    BOARD

    expect { view.show_board(board.grid) }.to output(expected_output).to_stdout
  end

  it 'plays out a simple pawn capture sequence and shows the board after each move' do
    board.setup_board
    view.show_board(board.grid)

    # White pawn e2 → e4
    board.move_piece([6, 4], [4, 4])
    view.show_board(board.grid)

    # Black pawn d7 → d5
    board.move_piece([1, 3], [3, 3])
    view.show_board(board.grid)

    # White pawn captures on d5
    board.move_piece([4, 4], [3, 3])
    view.show_board(board.grid)

    expected_output = <<~BOARD
      8 BR BN BB BQ BK BB BN BR
      7 BP BP BP __ BP BP BP BP
      6 __ __ __ __ __ __ __ __
      5 __ __ __ WP __ __ __ __
      4 __ __ __ __ __ __ __ __
      3 __ __ __ __ __ __ __ __
      2 WP WP WP WP __ WP WP WP
      1 WR WN WB WQ WK WB WN WR
        a b c d e f g h
    BOARD

    expect { view.show_board(board.grid) }.to output(expected_output).to_stdout
  end
end

RSpec.describe 'Integration: capture showcase' do
  let(:board) { Board.new }
  let(:view)  { View.new }

  it 'demonstrates captures by multiple piece types' do
    board.setup_board
    view.show_board(board.grid)

    # 1) White pawn e2 -> e4
    board.move_piece([6, 4], [4, 4])
    view.show_board(board.grid)

    # 2) Black pawn d7 -> d5
    board.move_piece([1, 3], [3, 3])
    view.show_board(board.grid)

    # 3) White pawn e4 captures d5 (pawn capture)
    board.move_piece([4, 4], [3, 3])
    view.show_board(board.grid)

    # 4) Black knight b8 -> c6
    board.move_piece([0, 1], [2, 2])
    view.show_board(board.grid)

    # 5) White pawn d2 -> d4
    board.move_piece([6, 3], [4, 3])
    view.show_board(board.grid)

    # 6) Black knight c6 captures d4 (knight capture)
    board.move_piece([2, 2], [4, 3])
    view.show_board(board.grid)

    # 7) White bishop c1 -> g5
    board.move_piece([7, 2], [3, 6])
    view.show_board(board.grid)

    # 8) White bishop g5 captures f6 (bishop capture)
    board.move_piece([3, 6], [2, 5]) # takes nothing yet, just moving closer
    board.grid[1][6] = Pawn.new('Black') # drop a black pawn on g7
    view.show_board(board.grid)
    board.move_piece([2, 5], [1, 6]) # bishop captures pawn
    view.show_board(board.grid)

    # 9) Black rook h8 -> g8
    board.move_piece([0, 7], [0, 6])
    view.show_board(board.grid)

    # 10) Black rook g8 captures g2 (rook capture)
    board.move_piece([0, 6], [6, 6])
    view.show_board(board.grid)

    # 11) Free the white queen: move pawn d2 -> d3
    board.move_piece([6, 3], [5, 3]) if board.grid[6][3]
    view.show_board(board.grid)

    # 12) White queen d1 -> h5
    board.move_piece([7, 3], [3, 7])
    view.show_board(board.grid)

    # 13) Drop a black pawn at h7
    board.grid[1][7] = Pawn.new('Black')
    view.show_board(board.grid)

    # 14) White queen captures h7 (queen capture)
    board.move_piece([3, 7], [1, 7])
    view.show_board(board.grid)

    # Assertions
    expect(board.grid[1][7]).to be_a(Queen)
    expect(board.grid[1][7].color).to eq('White')
  end
end
