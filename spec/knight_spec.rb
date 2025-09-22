# spec/knight_spec.rb
require 'spec_helper'
require_relative '../lib/knight'

RSpec.describe Knight do
  let(:knight) { Knight.new('White') }

  it 'can move 2 up, 1 left' do
    expect(knight.valid_move?([4, 4], [2, 3])).to eq(:ok)
  end

  it 'can move 2 up, 1 right' do
    expect(knight.valid_move?([4, 4], [2, 5])).to eq(:ok)
  end

  it 'can move 2 down, 1 left' do
    expect(knight.valid_move?([4, 4], [6, 3])).to eq(:ok)
  end

  it 'can move 2 down, 1 right' do
    expect(knight.valid_move?([4, 4], [6, 5])).to eq(:ok)
  end

  it 'can move 2 left, 1 up' do
    expect(knight.valid_move?([4, 4], [3, 2])).to eq(:ok)
  end

  it 'can move 2 left, 1 down' do
    expect(knight.valid_move?([4, 4], [5, 2])).to eq(:ok)
  end

  it 'can move 2 right, 1 up' do
    expect(knight.valid_move?([4, 4], [3, 6])).to eq(:ok)
  end

  it 'can move 2 right, 1 down' do
    expect(knight.valid_move?([4, 4], [5, 6])).to eq(:ok)
  end

  it 'cannot move in a straight line' do
    expect(knight.valid_move?([4, 4], [4, 6])).to eq(:illegal)
  end

  it 'cannot move diagonally' do
    expect(knight.valid_move?([4, 4], [6, 6])).to eq(:illegal)
  end
end
