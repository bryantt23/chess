# spec/board_spec.rb
require 'spec_helper'
require_relative '../lib/board'
require_relative '../lib/pawn'
require_relative '../lib/rook'
require_relative '../lib/knight'
require_relative '../lib/bishop'
require_relative '../lib/queen'
require_relative '../lib/king'

RSpec.describe Board do
  let(:board) { Board.new }

  describe '#setup_board' do
    before { board.setup_board }

    it 'places black pawns on row 2' do
      (0..7).each do |col|
        piece = board.grid[1][col]  # row 2 (index 1)
        expect(piece).to be_a(Pawn)
        expect(piece.color).to eq('Black')
      end
    end

    it 'places white pawns on row 7' do
      (0..7).each do |col|
        piece = board.grid[6][col]  # row 7 (index 6)
        expect(piece).to be_a(Pawn)
        expect(piece.color).to eq('White')
      end
    end

    it 'places black major pieces on row 1' do
      row = board.grid[0]
      expect(row.map(&:class)).to eq(
        [Rook, Knight, Bishop, Queen, King, Bishop, Knight, Rook]
      )
      expect(row.map(&:color).uniq).to eq(['Black'])
    end

    it 'places white major pieces on row 8' do
      row = board.grid[7]
      expect(row.map(&:class)).to eq(
        [Rook, Knight, Bishop, Queen, King, Bishop, Knight, Rook]
      )
      expect(row.map(&:color).uniq).to eq(['White'])
    end
  end

  describe '#move_piece' do
    before { board.setup_board }

    it 'moves a white pawn forward one square' do
      board.move_piece([6, 4], [5, 4]) # White pawn at row 6 col 4 → row 5 col 4
      expect(board.grid[5][4]).to be_a(Pawn)
      expect(board.grid[5][4].color).to eq('White')
      expect(board.grid[6][4]).to be_nil
    end

    it 'lets white move a pawn and black move a knight' do
      board.move_piece([6, 4], [5, 4]) # White pawn from e2 → e3
      board.move_piece([0, 1], [2, 2]) # Black knight from b8 → c6

      # White pawn check
      expect(board.grid[5][4]).to be_a(Pawn)
      expect(board.grid[5][4].color).to eq('White')
      expect(board.grid[6][4]).to be_nil

      # Black knight check
      expect(board.grid[2][2]).to be_a(Knight)
      expect(board.grid[2][2].color).to eq('Black')
      expect(board.grid[0][1]).to be_nil
    end
  end
end
