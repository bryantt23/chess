# spec/pawn_spec.rb
require 'spec_helper'
require_relative '../lib/pawn'

RSpec.describe Pawn do
  let(:empty_grid) { Array.new(8) { Array.new(8) } }

  describe 'white pawn' do
    let(:pawn) { Pawn.new(:white) }

    context 'basic forward movement' do
      it 'can move forward one square' do
        expect(pawn.valid_move?([6, 4], [5, 4], empty_grid)).to eq(:ok)
      end

      it 'can move forward two squares on first move' do
        expect(pawn.valid_move?([6, 4], [4, 4], empty_grid)).to eq(:ok)
      end

      it 'cannot move two squares if not on starting rank' do
        expect(pawn.valid_move?([5, 4], [3, 4], empty_grid)).to eq(:illegal)
      end

      it 'cannot move backwards' do
        expect(pawn.valid_move?([5, 4], [6, 4], empty_grid)).to eq(:illegal)
      end

      it 'cannot move sideways' do
        expect(pawn.valid_move?([6, 4], [6, 5], empty_grid)).to eq(:illegal)
      end
    end

    context 'blocked movement' do
      it 'cannot move forward one square if blocked' do
        grid = Array.new(8) { Array.new(8) }
        grid[5][4] = Pawn.new(:black)
        expect(pawn.valid_move?([6, 4], [5, 4], grid)).to eq(:blocked)
      end

      it 'cannot move forward two squares if path blocked' do
        grid = Array.new(8) { Array.new(8) }
        grid[5][4] = Pawn.new(:black)
        expect(pawn.valid_move?([6, 4], [4, 4], grid)).to eq(:blocked)
      end
    end

    context 'diagonal movement and captures' do
      it 'can capture diagonally if enemy present' do
        grid = Array.new(8) { Array.new(8) }
        grid[5][5] = Pawn.new(:black)
        expect(pawn.valid_move?([6, 4], [5, 5], grid)).to eq(:capture)
      end

      it 'cannot move diagonally into empty square' do
        grid = Array.new(8) { Array.new(8) }
        expect(pawn.valid_move?([6, 4], [5, 5], grid)).to eq(:illegal)
      end

      it 'cannot capture diagonally if same color piece' do
        grid = Array.new(8) { Array.new(8) }
        grid[5][5] = Pawn.new(:white)
        expect(pawn.valid_move?([6, 4], [5, 5], grid)).to eq(:blocked)
      end
    end

    context 'edge cases' do
      it 'cannot stay in same square' do
        expect(pawn.valid_move?([6, 4], [6, 4], empty_grid)).to eq(:illegal)
      end

      it 'cannot move diagonally backwards' do
        expect(pawn.valid_move?([6, 4], [7, 5], empty_grid)).to eq(:illegal)
      end
    end
  end

  describe 'black pawn' do
    let(:pawn) { Pawn.new(:black) }

    context 'basic forward movement' do
      it 'can move forward one square' do
        expect(pawn.valid_move?([1, 4], [2, 4], empty_grid)).to eq(:ok)
      end

      it 'can move forward two squares on first move' do
        expect(pawn.valid_move?([1, 4], [3, 4], empty_grid)).to eq(:ok)
      end

      it 'cannot move two squares if not on starting rank' do
        expect(pawn.valid_move?([2, 4], [4, 4], empty_grid)).to eq(:illegal)
      end

      it 'cannot move backwards' do
        expect(pawn.valid_move?([2, 4], [1, 4], empty_grid)).to eq(:illegal)
      end

      it 'cannot move sideways' do
        expect(pawn.valid_move?([1, 4], [1, 5], empty_grid)).to eq(:illegal)
      end
    end

    context 'blocked movement' do
      it 'cannot move forward one square if blocked' do
        grid = Array.new(8) { Array.new(8) }
        grid[2][4] = Pawn.new(:white)
        expect(pawn.valid_move?([1, 4], [2, 4], grid)).to eq(:blocked)
      end

      it 'cannot move forward two squares if path blocked' do
        grid = Array.new(8) { Array.new(8) }
        grid[2][4] = Pawn.new(:white)
        expect(pawn.valid_move?([1, 4], [3, 4], grid)).to eq(:blocked)
      end
    end

    context 'diagonal movement and captures' do
      it 'can capture diagonally if enemy present' do
        grid = Array.new(8) { Array.new(8) }
        grid[2][5] = Pawn.new(:white)
        expect(pawn.valid_move?([1, 4], [2, 5], grid)).to eq(:capture)
      end

      it 'cannot move diagonally into empty square' do
        grid = Array.new(8) { Array.new(8) }
        expect(pawn.valid_move?([1, 4], [2, 5], grid)).to eq(:illegal)
      end

      it 'cannot capture diagonally if same color piece' do
        grid = Array.new(8) { Array.new(8) }
        grid[2][5] = Pawn.new(:black)
        expect(pawn.valid_move?([1, 4], [2, 5], grid)).to eq(:blocked)
      end
    end

    context 'edge cases' do
      it 'cannot stay in same square' do
        expect(pawn.valid_move?([1, 4], [1, 4], empty_grid)).to eq(:illegal)
      end

      it 'cannot move diagonally backwards' do
        expect(pawn.valid_move?([1, 4], [0, 5], empty_grid)).to eq(:illegal)
      end
    end
  end
end
