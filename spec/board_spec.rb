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

    it 'places white pawns on row 2' do
      (0..7).each do |col|
        piece = board.grid[1][col]  # row 2 (index 1)
        expect(piece).to be_a(Pawn)
        expect(piece.color).to eq('White')
      end
    end

    it 'places black pawns on row 7' do
      (0..7).each do |col|
        piece = board.grid[6][col]  # row 7 (index 6)
        expect(piece).to be_a(Pawn)
        expect(piece.color).to eq('Black')
      end
    end

    it 'places white major pieces on row 1' do
      row = board.grid[0]
      expect(row.map(&:class)).to eq(
        [Rook, Knight, Bishop, Queen, King, Bishop, Knight, Rook]
      )
      expect(row.map(&:color).uniq).to eq(['White'])
    end

    it 'places black major pieces on row 8' do
      row = board.grid[7]
      expect(row.map(&:class)).to eq(
        [Rook, Knight, Bishop, Queen, King, Bishop, Knight, Rook]
      )
      expect(row.map(&:color).uniq).to eq(['Black'])
    end
  end
end
