# spec/king_spec.rb
require 'spec_helper'
require_relative '../lib/king'

RSpec.describe King do
  let(:king) { King.new('White') }

  context 'valid moves' do
    it 'can move one square up' do
      expect(king.valid_move?([4, 4], [5, 4])).to eq(:ok)
    end

    it 'can move one square down' do
      expect(king.valid_move?([4, 4], [3, 4])).to eq(:ok)
    end

    it 'can move one square left' do
      expect(king.valid_move?([4, 4], [4, 3])).to eq(:ok)
    end

    it 'can move one square right' do
      expect(king.valid_move?([4, 4], [4, 5])).to eq(:ok)
    end

    it 'can move one square diagonally' do
      expect(king.valid_move?([4, 4], [5, 5])).to eq(:ok)
      expect(king.valid_move?([4, 4], [5, 3])).to eq(:ok)
      expect(king.valid_move?([4, 4], [3, 5])).to eq(:ok)
      expect(king.valid_move?([4, 4], [3, 3])).to eq(:ok)
    end
  end

  context 'invalid moves' do
    it 'cannot move more than one square' do
      expect(king.valid_move?([4, 4], [6, 4])).to eq(:illegal)
      expect(king.valid_move?([4, 4], [4, 6])).to eq(:illegal)
      expect(king.valid_move?([4, 4], [6, 6])).to eq(:illegal)
    end

    it 'cannot stay in place' do
      expect(king.valid_move?([4, 4], [4, 4])).to eq(:illegal)
    end
  end
end
