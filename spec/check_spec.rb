# spec/check_spec.rb
require 'spec_helper'
require_relative '../lib/board'
require_relative '../lib/rook'
require_relative '../lib/king'
require_relative '../lib/bishop'
require_relative '../lib/pawn'
require_relative '../lib/knight'
require_relative '../lib/queen'

RSpec.describe 'Check detection with Rooks' do
  let(:board) { Board.new }

  describe 'White king in check' do
    it 'is in check from a black rook above' do
      board.grid = Array.new(8) { Array.new(8) }
      board.grid[4][4] = King.new('White')   # e4
      board.grid[0][4] = Rook.new('Black')   # e8

      expect(board.is_check?('White')).to be true
    end

    it 'is in check from a black rook below' do
      board.grid = Array.new(8) { Array.new(8) }
      board.grid[4][4] = King.new('White')   # e4
      board.grid[7][4] = Rook.new('Black')   # e1

      expect(board.is_check?('White')).to be true
    end

    it 'is in check from a black rook to the left' do
      board.grid = Array.new(8) { Array.new(8) }
      board.grid[4][4] = King.new('White')   # e4
      board.grid[4][0] = Rook.new('Black')   # a4

      expect(board.is_check?('White')).to be true
    end

    it 'is in check from a black rook to the right' do
      board.grid = Array.new(8) { Array.new(8) }
      board.grid[4][4] = King.new('White')   # e4
      board.grid[4][7] = Rook.new('Black')   # h4

      expect(board.is_check?('White')).to be true
    end

    it 'is not in check when a piece blocks the rook' do
      board.grid = Array.new(8) { Array.new(8) }
      board.grid[4][4] = King.new('White')
      board.grid[0][4] = Rook.new('Black')
      board.grid[2][4] = Rook.new('White')   # block

      expect(board.is_check?('White')).to be false
    end

    it 'is not in check from a rook of the same color' do
      board.grid = Array.new(8) { Array.new(8) }
      board.grid[4][4] = King.new('White')
      board.grid[0][4] = Rook.new('White')

      expect(board.is_check?('White')).to be false
    end
  end

  describe 'Black king in check' do
    it 'is in check from a white rook above' do
      board.grid = Array.new(8) { Array.new(8) }
      board.grid[4][4] = King.new('Black')   # e4
      board.grid[0][4] = Rook.new('White')   # e8

      expect(board.is_check?('Black')).to be true
    end

    it 'is in check from a white rook below' do
      board.grid = Array.new(8) { Array.new(8) }
      board.grid[4][4] = King.new('Black')   # e4
      board.grid[7][4] = Rook.new('White')   # e1

      expect(board.is_check?('Black')).to be true
    end

    it 'is in check from a white rook to the left' do
      board.grid = Array.new(8) { Array.new(8) }
      board.grid[4][4] = King.new('Black')   # e4
      board.grid[4][0] = Rook.new('White')   # a4

      expect(board.is_check?('Black')).to be true
    end

    it 'is in check from a white rook to the right' do
      board.grid = Array.new(8) { Array.new(8) }
      board.grid[4][4] = King.new('Black')   # e4
      board.grid[4][7] = Rook.new('White')   # h4

      expect(board.is_check?('Black')).to be true
    end

    it 'is not in check when a piece blocks the rook' do
      board.grid = Array.new(8) { Array.new(8) }
      board.grid[4][4] = King.new('Black')
      board.grid[0][4] = Rook.new('White')
      board.grid[2][4] = Rook.new('Black')   # block

      expect(board.is_check?('Black')).to be false
    end

    it 'is not in check from a rook of the same color' do
      board.grid = Array.new(8) { Array.new(8) }
      board.grid[4][4] = King.new('Black')
      board.grid[0][4] = Rook.new('Black')

      expect(board.is_check?('Black')).to be false
    end
  end
end

RSpec.describe 'Check detection with bishops' do
  let(:board) { Board.new }

  context 'White king in check by black bishop' do
    it 'detects check from top-left diagonal' do
      board.grid = Array.new(8) { Array.new(8) }
      board.grid[4][4] = King.new('White')   # e4
      board.grid[0][0] = Bishop.new('Black') # a8
      expect(board.is_check?('White')).to be true
    end

    it 'detects check from top-right diagonal' do
      board.grid = Array.new(8) { Array.new(8) }
      board.grid[4][4] = King.new('White')   # e4
      board.grid[1][7] = Bishop.new('Black') # h8
      expect(board.is_check?('White')).to be true
    end

    it 'detects check from bottom-left diagonal' do
      board.grid = Array.new(8) { Array.new(8) }
      board.grid[4][4] = King.new('White')   # e4
      board.grid[7][1] = Bishop.new('Black') # b1
      expect(board.is_check?('White')).to be true
    end

    it 'detects check from bottom-right diagonal' do
      board.grid = Array.new(8) { Array.new(8) }
      board.grid[4][4] = King.new('White')   # e4
      board.grid[7][7] = Bishop.new('Black') # h1
      expect(board.is_check?('White')).to be true
    end

    it 'does not detect check when blocked by own piece' do
      board.grid = Array.new(8) { Array.new(8) }
      board.grid[4][4] = King.new('White')
      board.grid[0][0] = Bishop.new('Black')
      board.grid[2][2] = Pawn.new('Black') # blocker
      expect(board.is_check?('White')).to be false
    end

    it 'does not detect check when diagonals don’t align' do
      board.grid = Array.new(8) { Array.new(8) }
      board.grid[4][4] = King.new('White')
      board.grid[0][1] = Bishop.new('Black') # not aligned
      expect(board.is_check?('White')).to be false
    end
  end

  context 'Black king in check by white bishop' do
    it 'detects check from bottom-left diagonal' do
      board.grid = Array.new(8) { Array.new(8) }
      board.grid[3][3] = King.new('Black')   # d5
      board.grid[7][7] = Bishop.new('White') # h1
      expect(board.is_check?('Black')).to be true
    end

    it 'detects check from top-right diagonal' do
      board.grid = Array.new(8) { Array.new(8) }
      board.grid[3][3] = King.new('Black')   # d5
      board.grid[0][6] = Bishop.new('White') # g8
      expect(board.is_check?('Black')).to be true
    end

    it 'does not detect check when blocked' do
      board.grid = Array.new(8) { Array.new(8) }
      board.grid[3][3] = King.new('Black')
      board.grid[0][0] = Bishop.new('White')
      board.grid[2][2] = Pawn.new('White') # blocker
      expect(board.is_check?('Black')).to be false
    end

    it 'does not detect check when not aligned' do
      board.grid = Array.new(8) { Array.new(8) }
      board.grid[3][3] = King.new('Black')
      board.grid[0][5] = Bishop.new('White') # off diagonal
      expect(board.is_check?('Black')).to be false
    end
  end
end

RSpec.describe Board do
  let(:board) { Board.new }

  describe '#is_check? with Queen' do
    context 'when White king is checked by Black queen' do
      it 'detects check from above' do
        board.grid = Array.new(8) { Array.new(8) }
        board.grid[4][4] = King.new('White') # e4
        board.grid[0][4] = Queen.new('Black') # e8
        expect(board.is_check?('White')).to be true
      end

      it 'detects check from below' do
        board.grid = Array.new(8) { Array.new(8) }
        board.grid[4][4] = King.new('White')
        board.grid[7][4] = Queen.new('Black') # e1
        expect(board.is_check?('White')).to be true
      end

      it 'detects check from left' do
        board.grid = Array.new(8) { Array.new(8) }
        board.grid[4][4] = King.new('White')
        board.grid[4][0] = Queen.new('Black') # a4
        expect(board.is_check?('White')).to be true
      end

      it 'detects check from right' do
        board.grid = Array.new(8) { Array.new(8) }
        board.grid[4][4] = King.new('White')
        board.grid[4][7] = Queen.new('Black') # h4
        expect(board.is_check?('White')).to be true
      end

      it 'detects check from top-left diagonal' do
        board.grid = Array.new(8) { Array.new(8) }
        board.grid[4][4] = King.new('White')
        board.grid[0][0] = Queen.new('Black') # a8
        expect(board.is_check?('White')).to be true
      end

      it 'detects check from top-right diagonal' do
        board.grid = Array.new(8) { Array.new(8) }
        board.grid[4][4] = King.new('White')
        board.grid[1][7] = Queen.new('Black') # h8
        expect(board.is_check?('White')).to be true
      end

      it 'detects check from bottom-left diagonal' do
        board.grid = Array.new(8) { Array.new(8) }
        board.grid[4][4] = King.new('White')
        board.grid[7][1] = Queen.new('Black') # b1
        expect(board.is_check?('White')).to be true
      end

      it 'detects check from bottom-right diagonal' do
        board.grid = Array.new(8) { Array.new(8) }
        board.grid[4][4] = King.new('White')
        board.grid[7][7] = Queen.new('Black') # h1
        expect(board.is_check?('White')).to be true
      end

      it 'does not detect check if blocked by another piece' do
        board.grid = Array.new(8) { Array.new(8) }
        board.grid[4][4] = King.new('White')
        board.grid[0][4] = Queen.new('Black') # e8
        board.grid[2][4] = Pawn.new('Black')  # block
        expect(board.is_check?('White')).to be false
      end

      it 'does not detect check if queen is misaligned' do
        board.grid = Array.new(8) { Array.new(8) }
        board.grid[4][4] = King.new('White')
        board.grid[0][3] = Queen.new('Black') # d8, not aligned
        expect(board.is_check?('White')).to be false
      end
    end

    context 'when Black king is checked by White queen' do
      it 'detects check from above' do
        board.grid = Array.new(8) { Array.new(8) }
        board.grid[3][3] = King.new('Black')  # d5
        board.grid[0][3] = Queen.new('White') # d8
        expect(board.is_check?('Black')).to be true
      end

      it 'detects check from below' do
        board.grid = Array.new(8) { Array.new(8) }
        board.grid[3][3] = King.new('Black')
        board.grid[7][3] = Queen.new('White') # d1
        expect(board.is_check?('Black')).to be true
      end

      it 'detects check from left' do
        board.grid = Array.new(8) { Array.new(8) }
        board.grid[3][3] = King.new('Black')
        board.grid[3][0] = Queen.new('White') # a5
        expect(board.is_check?('Black')).to be true
      end

      it 'detects check from right' do
        board.grid = Array.new(8) { Array.new(8) }
        board.grid[3][3] = King.new('Black')
        board.grid[3][7] = Queen.new('White') # h5
        expect(board.is_check?('Black')).to be true
      end

      it 'detects check from top-left diagonal' do
        board.grid = Array.new(8) { Array.new(8) }
        board.grid[3][3] = King.new('Black')
        board.grid[0][0] = Queen.new('White') # a8
        expect(board.is_check?('Black')).to be true
      end

      it 'detects check from top-right diagonal' do
        board.grid = Array.new(8) { Array.new(8) }
        board.grid[3][3] = King.new('Black')
        board.grid[0][6] = Queen.new('White') # g8
        expect(board.is_check?('Black')).to be true
      end

      it 'detects check from bottom-left diagonal' do
        board.grid = Array.new(8) { Array.new(8) }
        board.grid[3][3] = King.new('Black')
        board.grid[6][0] = Queen.new('White')
        expect(board.is_check?('Black')).to be true
      end

      it 'detects check from bottom-right diagonal' do
        board.grid = Array.new(8) { Array.new(8) }
        board.grid[3][3] = King.new('Black')
        board.grid[7][7] = Queen.new('White') # h1
        expect(board.is_check?('Black')).to be true
      end

      it 'does not detect check if blocked by another piece' do
        board.grid = Array.new(8) { Array.new(8) }
        board.grid[3][3] = King.new('Black')
        board.grid[7][3] = Queen.new('White') # d1
        board.grid[5][3] = Pawn.new('White')  # block
        expect(board.is_check?('Black')).to be false
      end

      it 'does not detect check if queen is misaligned' do
        board.grid = Array.new(8) { Array.new(8) }
        board.grid[3][3] = King.new('Black')
        board.grid[2][1] = Queen.new('White') # b6, not aligned
        expect(board.is_check?('Black')).to be false
      end
    end
  end
end

RSpec.describe 'Check detection: Knight' do
  let(:board) { Board.new }

  context 'White king in danger' do
    it 'detects check from all 8 knight positions' do
      knight_moves = [
        [2, 3], [2, 5],   # 2 up, 1 left/right
        [6, 3], [6, 5],   # 2 down, 1 left/right
        [3, 2], [5, 2],   # 2 left, 1 up/down
        [3, 6], [5, 6]    # 2 right, 1 up/down
      ]

      knight_moves.each do |pos|
        board.grid = Array.new(8) { Array.new(8) }
        board.grid[4][4] = King.new('White')   # e4
        board.grid[pos[0]][pos[1]] = Knight.new('Black')
        expect(board.is_check?('White')).to be true
      end
    end

    it 'does not detect check if knight is not in L-shape' do
      board.grid = Array.new(8) { Array.new(8) }
      board.grid[4][4] = King.new('White')
      board.grid[4][6] = Knight.new('Black')   # straight line, invalid
      expect(board.is_check?('White')).to be false
    end
  end

  context 'Black king in danger' do
    it 'detects check from all 8 knight positions' do
      knight_moves = [
        [2, 3], [2, 5],
        [6, 3], [6, 5],
        [3, 2], [5, 2],
        [3, 6], [5, 6]
      ]

      knight_moves.each do |pos|
        board.grid = Array.new(8) { Array.new(8) }
        board.grid[4][4] = King.new('Black')   # e4
        board.grid[pos[0]][pos[1]] = Knight.new('White')
        expect(board.is_check?('Black')).to be true
      end
    end

    it 'does not detect check if knight is too far' do
      board.grid = Array.new(8) { Array.new(8) }
      board.grid[4][4] = King.new('Black')
      board.grid[0][0] = Knight.new('White')   # corner, far away
      expect(board.is_check?('Black')).to be false
    end
  end
end

RSpec.describe 'Check detection: Pawn' do
  let(:board) { Board.new }

  context 'White king in danger' do
    it 'detects check from a black pawn diagonally up-left' do
      board.grid = Array.new(8) { Array.new(8) }
      board.grid[4][4] = King.new('White')    # e4
      board.grid[3][3] = Pawn.new('Black')    # d5
      expect(board.is_check?('White')).to be true
    end

    it 'detects check from a black pawn diagonally up-right' do
      board.grid = Array.new(8) { Array.new(8) }
      board.grid[4][4] = King.new('White')
      board.grid[3][5] = Pawn.new('Black')    # f5
      expect(board.is_check?('White')).to be true
    end

    it 'does not detect check from black pawn directly above' do
      board.grid = Array.new(8) { Array.new(8) }
      board.grid[4][4] = King.new('White')
      board.grid[3][4] = Pawn.new('Black')    # e5 forward only
      expect(board.is_check?('White')).to be false
    end
  end

  context 'Black king in danger' do
    it 'detects check from a white pawn diagonally down-left' do
      board.grid = Array.new(8) { Array.new(8) }
      board.grid[4][4] = King.new('Black')    # e4
      board.grid[5][3] = Pawn.new('White')    # d3
      expect(board.is_check?('Black')).to be true
    end

    it 'detects check from a white pawn diagonally down-right' do
      board.grid = Array.new(8) { Array.new(8) }
      board.grid[4][4] = King.new('Black')
      board.grid[5][5] = Pawn.new('White')    # f3
      expect(board.is_check?('Black')).to be true
    end

    it 'does not detect check from white pawn directly below' do
      board.grid = Array.new(8) { Array.new(8) }
      board.grid[4][4] = King.new('Black')
      board.grid[5][4] = Pawn.new('White')    # e3 forward only
      expect(board.is_check?('Black')).to be false
    end
  end
end

RSpec.describe 'Check detection: King vs King' do
  let(:board) { Board.new }

  context 'White king in danger from Black king' do
    it 'detects check from top' do
      board.grid = Array.new(8) { Array.new(8) }
      board.grid[4][4] = King.new('White')   # e4
      board.grid[3][4] = King.new('Black')   # e5
      expect(board.is_check?('White')).to be true
    end

    it 'detects check from bottom' do
      board.grid = Array.new(8) { Array.new(8) }
      board.grid[4][4] = King.new('White')
      board.grid[5][4] = King.new('Black')
      expect(board.is_check?('White')).to be true
    end

    it 'detects check from left' do
      board.grid = Array.new(8) { Array.new(8) }
      board.grid[4][4] = King.new('White')
      board.grid[4][3] = King.new('Black')
      expect(board.is_check?('White')).to be true
    end

    it 'detects check from right' do
      board.grid = Array.new(8) { Array.new(8) }
      board.grid[4][4] = King.new('White')
      board.grid[4][5] = King.new('Black')
      expect(board.is_check?('White')).to be true
    end

    it 'detects check from top-left diagonal' do
      board.grid = Array.new(8) { Array.new(8) }
      board.grid[4][4] = King.new('White')
      board.grid[3][3] = King.new('Black')
      expect(board.is_check?('White')).to be true
    end

    it 'detects check from top-right diagonal' do
      board.grid = Array.new(8) { Array.new(8) }
      board.grid[4][4] = King.new('White')
      board.grid[3][5] = King.new('Black')
      expect(board.is_check?('White')).to be true
    end

    it 'detects check from bottom-left diagonal' do
      board.grid = Array.new(8) { Array.new(8) }
      board.grid[4][4] = King.new('White')
      board.grid[5][3] = King.new('Black')
      expect(board.is_check?('White')).to be true
    end

    it 'detects check from bottom-right diagonal' do
      board.grid = Array.new(8) { Array.new(8) }
      board.grid[4][4] = King.new('White')
      board.grid[5][5] = King.new('Black')
      expect(board.is_check?('White')).to be true
    end

    it 'does not detect check if Black king is two squares away' do
      board.grid = Array.new(8) { Array.new(8) }
      board.grid[4][4] = King.new('White')
      board.grid[2][4] = King.new('Black')
      expect(board.is_check?('White')).to be false
    end
  end

  context 'Black king in danger from White king' do
    it 'detects check from top' do
      board.grid = Array.new(8) { Array.new(8) }
      board.grid[4][4] = King.new('Black')
      board.grid[3][4] = King.new('White')
      expect(board.is_check?('Black')).to be true
    end

    it 'detects check from bottom' do
      board.grid = Array.new(8) { Array.new(8) }
      board.grid[4][4] = King.new('Black')
      board.grid[5][4] = King.new('White')
      expect(board.is_check?('Black')).to be true
    end

    it 'detects check from left' do
      board.grid = Array.new(8) { Array.new(8) }
      board.grid[4][4] = King.new('Black')
      board.grid[4][3] = King.new('White')
      expect(board.is_check?('Black')).to be true
    end

    it 'detects check from right' do
      board.grid = Array.new(8) { Array.new(8) }
      board.grid[4][4] = King.new('Black')
      board.grid[4][5] = King.new('White')
      expect(board.is_check?('Black')).to be true
    end

    it 'detects check from diagonals' do
      board.grid = Array.new(8) { Array.new(8) }
      board.grid[4][4] = King.new('Black')
      board.grid[3][3] = King.new('White')
      expect(board.is_check?('Black')).to be true

      board.grid = Array.new(8) { Array.new(8) }
      board.grid[4][4] = King.new('Black')
      board.grid[5][5] = King.new('White')
      expect(board.is_check?('Black')).to be true
    end

    it 'does not detect check if White king is two squares away' do
      board.grid = Array.new(8) { Array.new(8) }
      board.grid[4][4] = King.new('Black')
      board.grid[6][4] = King.new('White')
      expect(board.is_check?('Black')).to be false
    end
  end
end
