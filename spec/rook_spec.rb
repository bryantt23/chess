# spec/rook_spec.rb
require 'spec_helper'
require_relative '../lib/rook'

RSpec.describe Rook do
  let(:rook) { Rook.new('White') }

  it 'can move vertically any number of squares' do
    expect(rook.valid_move?([4, 4], [0, 4])).to be true   # up
    expect(rook.valid_move?([4, 4], [7, 4])).to be true   # down
  end

  it 'can move horizontally any number of squares' do
    expect(rook.valid_move?([4, 4], [4, 0])).to be true   # left
    expect(rook.valid_move?([4, 4], [4, 7])).to be true   # right
  end

  it 'cannot move diagonally' do
    expect(rook.valid_move?([4, 4], [6, 6])).to be false
    expect(rook.valid_move?([4, 4], [2, 6])).to be false
  end

  it 'cannot stay in the same place' do
    expect(rook.valid_move?([4, 4], [4, 4])).to be false
  end
end
