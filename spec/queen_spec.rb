# spec/queen_spec.rb
require 'spec_helper'
require_relative '../lib/queen'

RSpec.describe Queen do
  let(:queen) { Queen.new('White') }

  context 'valid moves' do
    it 'can move vertically' do
      expect(queen.valid_move?([4, 4], [7, 4])).to eq(:ok)
    end

    it 'can move horizontally' do
      expect(queen.valid_move?([4, 4], [4, 7])).to eq(:ok)
    end

    it 'can move diagonally' do
      expect(queen.valid_move?([4, 4], [7, 7])).to eq(:ok)
      expect(queen.valid_move?([4, 4], [1, 7])).to eq(:ok)
    end
  end

  context 'invalid moves' do
    it 'cannot move like a knight' do
      expect(queen.valid_move?([4, 4], [6, 5])).to eq(:illegal)
    end

    it 'cannot stay in place' do
      expect(queen.valid_move?([4, 4], [4, 4])).to eq(:illegal)
    end

    it 'cannot move to non-straight non-diagonal square' do
      expect(queen.valid_move?([4, 4], [5, 6])).to eq(:illegal)
    end
  end
end
