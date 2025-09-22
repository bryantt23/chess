# spec/rook_spec.rb
require 'spec_helper'
require_relative '../lib/rook'

RSpec.describe Rook do
  let(:rook) { Rook.new('White') }
  empty_grid = Array.new(8) { Array.new(8) }

  it 'can move vertically any number of squares' do
    expect(rook.valid_move?([4, 4], [0, 4], empty_grid)).to eq(:ok)   # up
    expect(rook.valid_move?([4, 4], [7, 4], empty_grid)).to eq(:ok)   # down
  end

  it 'can move horizontally any number of squares' do
    expect(rook.valid_move?([4, 4], [4, 0], empty_grid)).to eq(:ok)   # left
    expect(rook.valid_move?([4, 4], [4, 7], empty_grid)).to eq(:ok)   # right
  end

  it 'cannot move diagonally' do
    expect(rook.valid_move?([4, 4], [6, 6], empty_grid)).to eq(:illegal)
    expect(rook.valid_move?([4, 4], [2, 6], empty_grid)).to eq(:illegal)
  end

  it 'cannot stay in the same place' do
    expect(rook.valid_move?([4, 4], [4, 4])).to eq(:illegal)
  end
end
