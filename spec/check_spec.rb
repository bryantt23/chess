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
      board.set_grid(Array.new(8) { Array.new(8) })
      board.grid[4][4] = King.new(:white) # e4
      board.grid[0][4] = Rook.new(:black) # e8

      expect(board.is_check?(:white)).to be true
    end

    it 'is in check from a black rook below' do
      board.set_grid(Array.new(8) { Array.new(8) })
      board.grid[4][4] = King.new(:white) # e4
      board.grid[7][4] = Rook.new(:black) # e1

      expect(board.is_check?(:white)).to be true
    end

    it 'is in check from a black rook to the left' do
      board.set_grid(Array.new(8) { Array.new(8) })
      board.grid[4][4] = King.new(:white) # e4
      board.grid[4][0] = Rook.new(:black) # a4

      expect(board.is_check?(:white)).to be true
    end

    it 'is in check from a black rook to the right' do
      board.set_grid(Array.new(8) { Array.new(8) })
      board.grid[4][4] = King.new(:white) # e4
      board.grid[4][7] = Rook.new(:black) # h4

      expect(board.is_check?(:white)).to be true
    end

    it 'is not in check when a piece blocks the rook' do
      board.set_grid(Array.new(8) { Array.new(8) })
      board.grid[4][4] = King.new(:white)
      board.grid[0][4] = Rook.new(:black)
      board.grid[2][4] = Rook.new(:white) # block

      expect(board.is_check?(:white)).to be false
    end

    it 'is not in check from a rook of the same color' do
      board.set_grid(Array.new(8) { Array.new(8) })
      board.grid[4][4] = King.new(:white)
      board.grid[0][4] = Rook.new(:white)

      expect(board.is_check?(:white)).to be false
    end
  end

  describe 'Black king in check' do
    it 'is in check from a white rook above' do
      board.set_grid(Array.new(8) { Array.new(8) })
      board.grid[4][4] = King.new(:black) # e4
      board.grid[0][4] = Rook.new(:white) # e8

      expect(board.is_check?(:black)).to be true
    end

    it 'is in check from a white rook below' do
      board.set_grid(Array.new(8) { Array.new(8) })
      board.grid[4][4] = King.new(:black) # e4
      board.grid[7][4] = Rook.new(:white) # e1

      expect(board.is_check?(:black)).to be true
    end

    it 'is in check from a white rook to the left' do
      board.set_grid(Array.new(8) { Array.new(8) })
      board.grid[4][4] = King.new(:black) # e4
      board.grid[4][0] = Rook.new(:white) # a4

      expect(board.is_check?(:black)).to be true
    end

    it 'is in check from a white rook to the right' do
      board.set_grid(Array.new(8) { Array.new(8) })
      board.grid[4][4] = King.new(:black) # e4
      board.grid[4][7] = Rook.new(:white) # h4

      expect(board.is_check?(:black)).to be true
    end

    it 'is not in check when a piece blocks the rook' do
      board.set_grid(Array.new(8) { Array.new(8) })
      board.grid[4][4] = King.new(:black)
      board.grid[0][4] = Rook.new(:white)
      board.grid[2][4] = Rook.new(:black) # block

      expect(board.is_check?(:black)).to be false
    end

    it 'is not in check from a rook of the same color' do
      board.set_grid(Array.new(8) { Array.new(8) })
      board.grid[4][4] = King.new(:black)
      board.grid[0][4] = Rook.new(:black)

      expect(board.is_check?(:black)).to be false
    end
  end
end

RSpec.describe 'Check detection with bishops' do
  let(:board) { Board.new }

  context 'White king in check by black bishop' do
    it 'detects check from top-left diagonal' do
      board.set_grid(Array.new(8) { Array.new(8) })
      board.grid[4][4] = King.new(:white) # e4
      board.grid[0][0] = Bishop.new(:black) # a8
      expect(board.is_check?(:white)).to be true
    end

    it 'detects check from top-right diagonal' do
      board.set_grid(Array.new(8) { Array.new(8) })
      board.grid[4][4] = King.new(:white) # e4
      board.grid[1][7] = Bishop.new(:black) # h8
      expect(board.is_check?(:white)).to be true
    end

    it 'detects check from bottom-left diagonal' do
      board.set_grid(Array.new(8) { Array.new(8) })
      board.grid[4][4] = King.new(:white) # e4
      board.grid[7][1] = Bishop.new(:black) # b1
      expect(board.is_check?(:white)).to be true
    end

    it 'detects check from bottom-right diagonal' do
      board.set_grid(Array.new(8) { Array.new(8) })
      board.grid[4][4] = King.new(:white) # e4
      board.grid[7][7] = Bishop.new(:black) # h1
      expect(board.is_check?(:white)).to be true
    end

    it 'does not detect check when blocked by own piece' do
      board.set_grid(Array.new(8) { Array.new(8) })
      board.grid[4][4] = King.new(:white)
      board.grid[0][0] = Bishop.new(:black)
      board.grid[2][2] = Pawn.new(:black) # blocker
      expect(board.is_check?(:white)).to be false
    end

    it 'does not detect check when diagonals don’t align' do
      board.set_grid(Array.new(8) { Array.new(8) })
      board.grid[4][4] = King.new(:white)
      board.grid[0][1] = Bishop.new(:black) # not aligned
      expect(board.is_check?(:white)).to be false
    end
  end

  context 'Black king in check by white bishop' do
    it 'detects check from bottom-left diagonal' do
      board.set_grid(Array.new(8) { Array.new(8) })
      board.grid[3][3] = King.new(:black)   # d5
      board.grid[7][7] = Bishop.new(:white) # h1
      expect(board.is_check?(:black)).to be true
    end

    it 'detects check from top-right diagonal' do
      board.set_grid(Array.new(8) { Array.new(8) })
      board.grid[3][3] = King.new(:black) # d5
      board.grid[0][6] = Bishop.new(:white) # g8
      expect(board.is_check?(:black)).to be true
    end

    it 'does not detect check when blocked' do
      board.set_grid(Array.new(8) { Array.new(8) })
      board.grid[3][3] = King.new(:black)
      board.grid[0][0] = Bishop.new(:white)
      board.grid[2][2] = Pawn.new(:white) # blocker
      expect(board.is_check?(:black)).to be false
    end

    it 'does not detect check when not aligned' do
      board.set_grid(Array.new(8) { Array.new(8) })
      board.grid[3][3] = King.new(:black)
      board.grid[0][5] = Bishop.new(:white) # off diagonal
      expect(board.is_check?(:black)).to be false
    end
  end
end

RSpec.describe Board do
  let(:board) { Board.new }

  describe '#is_check? with Queen' do
    context 'when White king is checked by Black queen' do
      it 'detects check from above' do
        board.set_grid(Array.new(8) { Array.new(8) })
        board.grid[4][4] = King.new(:white) # e4
        board.grid[0][4] = Queen.new(:black) # e8
        expect(board.is_check?(:white)).to be true
      end

      it 'detects check from below' do
        board.set_grid(Array.new(8) { Array.new(8) })
        board.grid[4][4] = King.new(:white)
        board.grid[7][4] = Queen.new(:black) # e1
        expect(board.is_check?(:white)).to be true
      end

      it 'detects check from left' do
        board.set_grid(Array.new(8) { Array.new(8) })
        board.grid[4][4] = King.new(:white)
        board.grid[4][0] = Queen.new(:black) # a4
        expect(board.is_check?(:white)).to be true
      end

      it 'detects check from right' do
        board.set_grid(Array.new(8) { Array.new(8) })
        board.grid[4][4] = King.new(:white)
        board.grid[4][7] = Queen.new(:black) # h4
        expect(board.is_check?(:white)).to be true
      end

      it 'detects check from top-left diagonal' do
        board.set_grid(Array.new(8) { Array.new(8) })
        board.grid[4][4] = King.new(:white)
        board.grid[0][0] = Queen.new(:black) # a8
        expect(board.is_check?(:white)).to be true
      end

      it 'detects check from top-right diagonal' do
        board.set_grid(Array.new(8) { Array.new(8) })
        board.grid[4][4] = King.new(:white)
        board.grid[1][7] = Queen.new(:black) # h8
        expect(board.is_check?(:white)).to be true
      end

      it 'detects check from bottom-left diagonal' do
        board.set_grid(Array.new(8) { Array.new(8) })
        board.grid[4][4] = King.new(:white)
        board.grid[7][1] = Queen.new(:black) # b1
        expect(board.is_check?(:white)).to be true
      end

      it 'detects check from bottom-right diagonal' do
        board.set_grid(Array.new(8) { Array.new(8) })
        board.grid[4][4] = King.new(:white)
        board.grid[7][7] = Queen.new(:black) # h1
        expect(board.is_check?(:white)).to be true
      end

      it 'does not detect check if blocked by another piece' do
        board.set_grid(Array.new(8) { Array.new(8) })
        board.grid[4][4] = King.new(:white)
        board.grid[0][4] = Queen.new(:black) # e8
        board.grid[2][4] = Pawn.new(:black)  # block
        expect(board.is_check?(:white)).to be false
      end

      it 'does not detect check if queen is misaligned' do
        board.set_grid(Array.new(8) { Array.new(8) })
        board.grid[4][4] = King.new(:white)
        board.grid[0][3] = Queen.new(:black) # d8, not aligned
        expect(board.is_check?(:white)).to be false
      end
    end

    context 'when Black king is checked by White queen' do
      it 'detects check from above' do
        board.set_grid(Array.new(8) { Array.new(8) })
        board.grid[3][3] = King.new(:black)  # d5
        board.grid[0][3] = Queen.new(:white) # d8
        expect(board.is_check?(:black)).to be true
      end

      it 'detects check from below' do
        board.set_grid(Array.new(8) { Array.new(8) })
        board.grid[3][3] = King.new(:black)
        board.grid[7][3] = Queen.new(:white) # d1
        expect(board.is_check?(:black)).to be true
      end

      it 'detects check from left' do
        board.set_grid(Array.new(8) { Array.new(8) })
        board.grid[3][3] = King.new(:black)
        board.grid[3][0] = Queen.new(:white) # a5
        expect(board.is_check?(:black)).to be true
      end

      it 'detects check from right' do
        board.set_grid(Array.new(8) { Array.new(8) })
        board.grid[3][3] = King.new(:black)
        board.grid[3][7] = Queen.new(:white) # h5
        expect(board.is_check?(:black)).to be true
      end

      it 'detects check from top-left diagonal' do
        board.set_grid(Array.new(8) { Array.new(8) })
        board.grid[3][3] = King.new(:black)
        board.grid[0][0] = Queen.new(:white) # a8
        expect(board.is_check?(:black)).to be true
      end

      it 'detects check from top-right diagonal' do
        board.set_grid(Array.new(8) { Array.new(8) })
        board.grid[3][3] = King.new(:black)
        board.grid[0][6] = Queen.new(:white) # g8
        expect(board.is_check?(:black)).to be true
      end

      it 'detects check from bottom-left diagonal' do
        board.set_grid(Array.new(8) { Array.new(8) })
        board.grid[3][3] = King.new(:black)
        board.grid[6][0] = Queen.new(:white)
        expect(board.is_check?(:black)).to be true
      end

      it 'detects check from bottom-right diagonal' do
        board.set_grid(Array.new(8) { Array.new(8) })
        board.grid[3][3] = King.new(:black)
        board.grid[7][7] = Queen.new(:white) # h1
        expect(board.is_check?(:black)).to be true
      end

      it 'does not detect check if blocked by another piece' do
        board.set_grid(Array.new(8) { Array.new(8) })
        board.grid[3][3] = King.new(:black)
        board.grid[7][3] = Queen.new(:white) # d1
        board.grid[5][3] = Pawn.new(:white)  # block
        expect(board.is_check?(:black)).to be false
      end

      it 'does not detect check if queen is misaligned' do
        board.set_grid(Array.new(8) { Array.new(8) })
        board.grid[3][3] = King.new(:black)
        board.grid[2][1] = Queen.new(:white) # b6, not aligned
        expect(board.is_check?(:black)).to be false
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
        board.set_grid(Array.new(8) { Array.new(8) })
        board.grid[4][4] = King.new(:white) # e4
        board.grid[pos[0]][pos[1]] = Knight.new(:black)
        expect(board.is_check?(:white)).to be true
      end
    end

    it 'does not detect check if knight is not in L-shape' do
      board.set_grid(Array.new(8) { Array.new(8) })
      board.grid[4][4] = King.new(:white)
      board.grid[4][6] = Knight.new(:black)   # straight line, invalid
      expect(board.is_check?(:white)).to be false
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
        board.set_grid(Array.new(8) { Array.new(8) })
        board.grid[4][4] = King.new(:black)   # e4
        board.grid[pos[0]][pos[1]] = Knight.new(:white)
        expect(board.is_check?(:black)).to be true
      end
    end

    it 'does not detect check if knight is too far' do
      board.set_grid(Array.new(8) { Array.new(8) })
      board.grid[4][4] = King.new(:black)
      board.grid[0][0] = Knight.new(:white) # corner, far away
      expect(board.is_check?(:black)).to be false
    end
  end
end

RSpec.describe 'Check detection: Pawn' do
  let(:board) { Board.new }

  context 'White king in danger' do
    it 'detects check from a black pawn diagonally up-left' do
      board.set_grid(Array.new(8) { Array.new(8) })
      board.grid[4][4] = King.new(:white) # e4
      board.grid[3][3] = Pawn.new(:black)    # d5
      expect(board.is_check?(:white)).to be true
    end

    it 'detects check from a black pawn diagonally up-right' do
      board.set_grid(Array.new(8) { Array.new(8) })
      board.grid[4][4] = King.new(:white)
      board.grid[3][5] = Pawn.new(:black)    # f5
      expect(board.is_check?(:white)).to be true
    end

    it 'does not detect check from black pawn directly above' do
      board.set_grid(Array.new(8) { Array.new(8) })
      board.grid[4][4] = King.new(:white)
      board.grid[3][4] = Pawn.new(:black)    # e5 forward only
      expect(board.is_check?(:white)).to be false
    end
  end

  context 'Black king in danger' do
    it 'detects check from a white pawn diagonally down-left' do
      board.set_grid(Array.new(8) { Array.new(8) })
      board.grid[4][4] = King.new(:black)    # e4
      board.grid[5][3] = Pawn.new(:white)    # d3
      expect(board.is_check?(:black)).to be true
    end

    it 'detects check from a white pawn diagonally down-right' do
      board.set_grid(Array.new(8) { Array.new(8) })
      board.grid[4][4] = King.new(:black)
      board.grid[5][5] = Pawn.new(:white)    # f3
      expect(board.is_check?(:black)).to be true
    end

    it 'does not detect check from white pawn directly below' do
      board.set_grid(Array.new(8) { Array.new(8) })
      board.grid[4][4] = King.new(:black)
      board.grid[5][4] = Pawn.new(:white)    # e3 forward only
      expect(board.is_check?(:black)).to be false
    end
  end
end

RSpec.describe 'Check detection: King vs King' do
  let(:board) { Board.new }

  context 'White king in danger from Black king' do
    it 'detects check from top' do
      board.set_grid(Array.new(8) { Array.new(8) })
      board.grid[4][4] = King.new(:white) # e4
      board.grid[3][4] = King.new(:black) # e5
      expect(board.is_check?(:white)).to be true
    end

    it 'detects check from bottom' do
      board.set_grid(Array.new(8) { Array.new(8) })
      board.grid[4][4] = King.new(:white)
      board.grid[5][4] = King.new(:black)
      expect(board.is_check?(:white)).to be true
    end

    it 'detects check from left' do
      board.set_grid(Array.new(8) { Array.new(8) })
      board.grid[4][4] = King.new(:white)
      board.grid[4][3] = King.new(:black)
      expect(board.is_check?(:white)).to be true
    end

    it 'detects check from right' do
      board.set_grid(Array.new(8) { Array.new(8) })
      board.grid[4][4] = King.new(:white)
      board.grid[4][5] = King.new(:black)
      expect(board.is_check?(:white)).to be true
    end

    it 'detects check from top-left diagonal' do
      board.set_grid(Array.new(8) { Array.new(8) })
      board.grid[4][4] = King.new(:white)
      board.grid[3][3] = King.new(:black)
      expect(board.is_check?(:white)).to be true
    end

    it 'detects check from top-right diagonal' do
      board.set_grid(Array.new(8) { Array.new(8) })
      board.grid[4][4] = King.new(:white)
      board.grid[3][5] = King.new(:black)
      expect(board.is_check?(:white)).to be true
    end

    it 'detects check from bottom-left diagonal' do
      board.set_grid(Array.new(8) { Array.new(8) })
      board.grid[4][4] = King.new(:white)
      board.grid[5][3] = King.new(:black)
      expect(board.is_check?(:white)).to be true
    end

    it 'detects check from bottom-right diagonal' do
      board.set_grid(Array.new(8) { Array.new(8) })
      board.grid[4][4] = King.new(:white)
      board.grid[5][5] = King.new(:black)
      expect(board.is_check?(:white)).to be true
    end

    it 'does not detect check if Black king is two squares away' do
      board.set_grid(Array.new(8) { Array.new(8) })
      board.grid[4][4] = King.new(:white)
      board.grid[2][4] = King.new(:black)
      expect(board.is_check?(:white)).to be false
    end
  end

  context 'Black king in danger from White king' do
    it 'detects check from top' do
      board.set_grid(Array.new(8) { Array.new(8) })
      board.grid[4][4] = King.new(:black)
      board.grid[3][4] = King.new(:white)
      expect(board.is_check?(:black)).to be true
    end

    it 'detects check from bottom' do
      board.set_grid(Array.new(8) { Array.new(8) })
      board.grid[4][4] = King.new(:black)
      board.grid[5][4] = King.new(:white)
      expect(board.is_check?(:black)).to be true
    end

    it 'detects check from left' do
      board.set_grid(Array.new(8) { Array.new(8) })
      board.grid[4][4] = King.new(:black)
      board.grid[4][3] = King.new(:white)
      expect(board.is_check?(:black)).to be true
    end

    it 'detects check from right' do
      board.set_grid(Array.new(8) { Array.new(8) })
      board.grid[4][4] = King.new(:black)
      board.grid[4][5] = King.new(:white)
      expect(board.is_check?(:black)).to be true
    end

    it 'detects check from diagonals' do
      board.set_grid(Array.new(8) { Array.new(8) })
      board.grid[4][4] = King.new(:black)
      board.grid[3][3] = King.new(:white)
      expect(board.is_check?(:black)).to be true

      board.set_grid(Array.new(8) { Array.new(8) })
      board.grid[4][4] = King.new(:black)
      board.grid[5][5] = King.new(:white)
      expect(board.is_check?(:black)).to be true
    end

    it 'does not detect check if White king is two squares away' do
      board.set_grid(Array.new(8) { Array.new(8) })
      board.grid[4][4] = King.new(:black)
      board.grid[6][4] = King.new(:white)
      expect(board.is_check?(:black)).to be false
    end
  end
end
