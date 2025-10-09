# spec/integration_scholars_mate_spec.rb
require 'spec_helper'
require_relative '../lib/board'
require_relative '../lib/view'

RSpec.describe 'Integration: Scholar’s Mate' do
  it 'detects checkmate after Qxf7#' do
    board = Board.new
    view  = View.new
    board.setup_board

    # 1. e4 e5
    board.move_piece([6, 4], [4, 4]) # e2 → e4
    board.move_piece([1, 4], [3, 4]) # e7 → e5

    # 2. Qh5 Nc6
    board.move_piece([7, 3], [3, 7]) # Qd1 → h5
    board.move_piece([0, 1], [2, 2]) # Nb8 → c6

    # 3. Bc4 Nf6
    board.move_piece([7, 5], [4, 2]) # Bf1 → c4
    board.move_piece([0, 6], [2, 5]) # Ng8 → f6

    # 4. Qxf7#
    result = board.move_piece([3, 7], [1, 5]) # Qh5 → f7 (checkmate)

    # --- Assertions ---
    expect(result).to eq(:capture)
    expect(board.is_check?(:black)).to be true
    expect(board.checkmate?(:black)).to be true

    view.show_board(board.grid)
  end
end
