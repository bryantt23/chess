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
    before(:each) { board.setup_board }

    it 'places black pawns on row 2' do
      (0..7).each do |col|
        piece = board.grid[1][col]
        expect(piece).to be_a(Pawn)
        expect(piece.color).to eq('Black')
      end
    end

    it 'places white pawns on row 7' do
      (0..7).each do |col|
        piece = board.grid[6][col]
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

  describe '#move_piece basic moves' do
    before(:each) { board.setup_board }

    it 'moves a white pawn forward one square' do
      board.move_piece([6, 4], [5, 4])
      expect(board.grid[5][4]).to be_a(Pawn)
      expect(board.grid[5][4].color).to eq('White')
      expect(board.grid[6][4]).to be_nil
    end

    it 'lets white move a pawn and black move a knight' do
      board.move_piece([6, 4], [5, 4])
      board.move_piece([0, 1], [2, 2])

      expect(board.grid[5][4]).to be_a(Pawn)
      expect(board.grid[6][4]).to be_nil
      expect(board.grid[2][2]).to be_a(Knight)
      expect(board.grid[0][1]).to be_nil
    end
  end

  describe '#move_piece with Rook movement' do
    before(:each) { board.grid = Array.new(8) { Array.new(8) } }

    it 'allows a valid horizontal move for a rook' do
      board.grid[4][4] = Rook.new('White')
      result = board.move_piece([4, 4], [4, 7])
      expect(result).to eq(:ok)
      expect(board.grid[4][7]).to be_a(Rook)
      expect(board.grid[4][4]).to be_nil
    end

    it 'rejects an invalid diagonal move for a rook' do
      board.grid[4][4] = Rook.new('White')
      result = board.move_piece([4, 4], [6, 6])
      expect(result).to eq(:illegal)
      expect(board.grid[4][4]).to be_a(Rook)
      expect(board.grid[6][6]).to be_nil
    end
  end

  describe '#move_piece with Bishop movement' do
    before(:each) { board.grid = Array.new(8) { Array.new(8) } }

    it 'allows a valid diagonal move for a bishop' do
      board.grid[4][4] = Bishop.new('White')
      result = board.move_piece([4, 4], [2, 2])
      expect(result).to eq(:ok)
      expect(board.grid[2][2]).to be_a(Bishop)
      expect(board.grid[4][4]).to be_nil
    end

    it 'rejects an invalid straight move for a bishop' do
      board.grid[4][4] = Bishop.new('White')
      result = board.move_piece([4, 4], [4, 5])
      expect(result).to eq(:illegal)
      expect(board.grid[4][4]).to be_a(Bishop)
      expect(board.grid[4][5]).to be_nil
    end
  end

  describe '#move_piece with Queen movement' do
    before(:each) { board.grid = Array.new(8) { Array.new(8) } }

    it 'allows a valid diagonal move for a queen' do
      board.grid[3][3] = Queen.new('White')
      result = board.move_piece([3, 3], [6, 6])
      expect(result).to eq(:ok)
      expect(board.grid[6][6]).to be_a(Queen)
      expect(board.grid[3][3]).to be_nil
    end

    it 'rejects an invalid L-shaped move for a queen' do
      board.grid[3][3] = Queen.new('White')
      result = board.move_piece([3, 3], [5, 4])
      expect(result).to eq(:illegal)
      expect(board.grid[3][3]).to be_a(Queen)
      expect(board.grid[5][4]).to be_nil
    end
  end

  describe '#move_piece with King movement' do
    before(:each) { board.grid = Array.new(8) { Array.new(8) } }

    it 'allows a valid one-square move for a king' do
      board.grid[4][4] = King.new('White')
      result = board.move_piece([4, 4], [5, 5])
      expect(result).to eq(:ok)
      expect(board.grid[5][5]).to be_a(King)
      expect(board.grid[4][4]).to be_nil
    end

    it 'rejects a move more than one square for a king' do
      board.grid[4][4] = King.new('White')
      result = board.move_piece([4, 4], [6, 4])
      expect(result).to eq(:illegal)
      expect(board.grid[4][4]).to be_a(King)
      expect(board.grid[6][4]).to be_nil
    end
  end

  describe '#move_piece with Knight movement' do
    before(:each) { board.grid = Array.new(8) { Array.new(8) } }

    it 'allows a valid L-shaped move for a knight' do
      board.grid[4][4] = Knight.new('White')
      result = board.move_piece([4, 4], [6, 5])
      expect(result).to eq(:ok)
      expect(board.grid[6][5]).to be_a(Knight)
      expect(board.grid[4][4]).to be_nil
    end

    it 'rejects a diagonal move for a knight' do
      board.grid[4][4] = Knight.new('White')
      result = board.move_piece([4, 4], [5, 5])
      expect(result).to eq(:illegal)
      expect(board.grid[4][4]).to be_a(Knight)
      expect(board.grid[5][5]).to be_nil
    end
  end

  describe '#move_piece with Pawn movement' do
    before(:each) { board.grid = Array.new(8) { Array.new(8) } }

    it 'allows a valid one-square forward move for a pawn' do
      board.grid[6][4] = Pawn.new('White')
      result = board.move_piece([6, 4], [5, 4])
      expect(result).to eq(:ok)
      expect(board.grid[5][4]).to be_a(Pawn)
      expect(board.grid[6][4]).to be_nil
    end

    it 'rejects a sideways move for a pawn' do
      board.grid[6][4] = Pawn.new('White')
      result = board.move_piece([6, 4], [6, 5])
      expect(result).to eq(:illegal)
      expect(board.grid[6][4]).to be_a(Pawn)
      expect(board.grid[6][5]).to be_nil
    end
  end

  describe '#move_piece with Rook blockers' do
    before(:each) { board.grid = Array.new(8) { Array.new(8) } }

    # ↓ down
    it 'rejects a rook move down when a piece blocks the path' do
      board.grid[0][0] = Rook.new('White')
      board.grid[3][0] = Pawn.new('White')
      result = board.move_piece([0, 0], [7, 0])
      expect(result).to eq(:blocked)
    end

    it 'allows a rook move down if clear' do
      board.grid[0][0] = Rook.new('White')
      result = board.move_piece([0, 0], [7, 0])
      expect(result).to eq(:ok)
    end

    # ↑ up
    it 'rejects a rook move up when a piece blocks the path' do
      board.grid[7][0] = Rook.new('White')
      board.grid[4][0] = Pawn.new('White')
      result = board.move_piece([7, 0], [0, 0])
      expect(result).to eq(:blocked)
    end

    it 'allows a rook move up if clear' do
      board.grid[7][0] = Rook.new('White')
      result = board.move_piece([7, 0], [0, 0])
      expect(result).to eq(:ok)
    end

    # → right
    it 'rejects a rook move right when a piece blocks the path' do
      board.grid[0][0] = Rook.new('White')
      board.grid[0][3] = Pawn.new('White')
      result = board.move_piece([0, 0], [0, 7])
      expect(result).to eq(:blocked)
    end

    it 'allows a rook move right if clear' do
      board.grid[0][0] = Rook.new('White')
      result = board.move_piece([0, 0], [0, 7])
      expect(result).to eq(:ok)
    end

    # ← left
    it 'rejects a rook move left when a piece blocks the path' do
      board.grid[0][7] = Rook.new('White')
      board.grid[0][4] = Pawn.new('White')
      result = board.move_piece([0, 7], [0, 0])
      expect(result).to eq(:blocked)
    end

    it 'allows a rook move left if clear' do
      board.grid[0][7] = Rook.new('White')
      result = board.move_piece([0, 7], [0, 0])
      expect(result).to eq(:ok)
    end
  end

  describe '#move_piece with Bishop blockers (all directions)' do
    # ↗ up-right
    it 'rejects a bishop move up-right when blocked' do
      board.grid = Array.new(8) { Array.new(8) }
      board.grid[4][4] = Bishop.new('White')
      board.grid[6][6] = Pawn.new('White') # block at g2

      result = board.move_piece([4, 4], [7, 7])
      expect(result).to eq(:blocked)
      expect(board.grid[4][4]).to be_a(Bishop)
      expect(board.grid[7][7]).to be_nil
    end

    it 'allows a bishop move up-right when clear' do
      board.grid = Array.new(8) { Array.new(8) }
      board.grid[4][4] = Bishop.new('White')

      result = board.move_piece([4, 4], [7, 7])
      expect(result).to eq(:ok)
      expect(board.grid[7][7]).to be_a(Bishop)
      expect(board.grid[4][4]).to be_nil
    end

    # ↖ up-left
    it 'rejects a bishop move up-left when blocked' do
      board.grid = Array.new(8) { Array.new(8) }
      board.grid[4][4] = Bishop.new('White')
      board.grid[6][2] = Pawn.new('White')

      result = board.move_piece([4, 4], [7, 1])
      expect(result).to eq(:blocked)
      expect(board.grid[4][4]).to be_a(Bishop)
      expect(board.grid[7][1]).to be_nil
    end

    it 'allows a bishop move up-left when clear' do
      board.grid = Array.new(8) { Array.new(8) }
      board.grid[4][4] = Bishop.new('White')

      result = board.move_piece([4, 4], [7, 1])
      expect(result).to eq(:ok)
      expect(board.grid[7][1]).to be_a(Bishop)
      expect(board.grid[4][4]).to be_nil
    end

    # ↘ down-right
    it 'rejects a bishop move down-right when blocked' do
      board.grid = Array.new(8) { Array.new(8) }
      board.grid[4][4] = Bishop.new('White')
      board.grid[2][6] = Pawn.new('White')

      result = board.move_piece([4, 4], [1, 7])
      expect(result).to eq(:blocked)
      expect(board.grid[4][4]).to be_a(Bishop)
      expect(board.grid[1][7]).to be_nil
    end

    it 'allows a bishop move down-right when clear' do
      board.grid = Array.new(8) { Array.new(8) }
      board.grid[4][4] = Bishop.new('White')

      result = board.move_piece([4, 4], [1, 7])
      expect(result).to eq(:ok)
      expect(board.grid[1][7]).to be_a(Bishop)
      expect(board.grid[4][4]).to be_nil
    end

    # ↙ down-left
    it 'rejects a bishop move down-left when blocked' do
      board.grid = Array.new(8) { Array.new(8) }
      board.grid[4][4] = Bishop.new('White')
      board.grid[2][2] = Pawn.new('White')

      result = board.move_piece([4, 4], [1, 1])
      expect(result).to eq(:blocked)
      expect(board.grid[4][4]).to be_a(Bishop)
      expect(board.grid[1][1]).to be_nil
    end

    it 'allows a bishop move down-left when clear' do
      board.grid = Array.new(8) { Array.new(8) }
      board.grid[4][4] = Bishop.new('White')

      result = board.move_piece([4, 4], [1, 1])
      expect(result).to eq(:ok)
      expect(board.grid[1][1]).to be_a(Bishop)
      expect(board.grid[4][4]).to be_nil
    end
  end

  describe '#move_piece with Queen blockers' do
    before(:each) { board.grid = Array.new(8) { Array.new(8) } }

    # Vertical ↓
    it 'rejects a queen move down when blocked' do
      board.grid[0][0] = Queen.new('White')
      board.grid[3][0] = Pawn.new('White')
      result = board.move_piece([0, 0], [7, 0])
      expect(result).to eq(:blocked)
    end

    it 'allows a queen move down if clear' do
      board.grid[0][0] = Queen.new('White')
      result = board.move_piece([0, 0], [7, 0])
      expect(result).to eq(:ok)
    end

    # Vertical ↑
    it 'rejects a queen move up when blocked' do
      board.grid[7][0] = Queen.new('White')
      board.grid[4][0] = Pawn.new('White')
      result = board.move_piece([7, 0], [0, 0])
      expect(result).to eq(:blocked)
    end

    it 'allows a queen move up if clear' do
      board.grid[7][0] = Queen.new('White')
      result = board.move_piece([7, 0], [0, 0])
      expect(result).to eq(:ok)
    end

    # Horizontal →
    it 'rejects a queen move right when blocked' do
      board.grid[0][0] = Queen.new('White')
      board.grid[0][3] = Pawn.new('White')
      result = board.move_piece([0, 0], [0, 7])
      expect(result).to eq(:blocked)
    end

    it 'allows a queen move right if clear' do
      board.grid[0][0] = Queen.new('White')
      result = board.move_piece([0, 0], [0, 7])
      expect(result).to eq(:ok)
    end

    # Horizontal ←
    it 'rejects a queen move left when blocked' do
      board.grid[0][7] = Queen.new('White')
      board.grid[0][4] = Pawn.new('White')
      result = board.move_piece([0, 7], [0, 0])
      expect(result).to eq(:blocked)
    end

    it 'allows a queen move left if clear' do
      board.grid[0][7] = Queen.new('White')
      result = board.move_piece([0, 7], [0, 0])
      expect(result).to eq(:ok)
    end

    # Diagonal ↘
    it 'rejects a queen move down-right when blocked' do
      board.grid[0][0] = Queen.new('White')
      board.grid[2][2] = Pawn.new('White')
      result = board.move_piece([0, 0], [3, 3])
      expect(result).to eq(:blocked)
    end

    it 'allows a queen move down-right if clear' do
      board.grid[0][0] = Queen.new('White')
      result = board.move_piece([0, 0], [3, 3])
      expect(result).to eq(:ok)
    end

    # Diagonal ↗
    it 'rejects a queen move up-right when blocked' do
      board.grid[7][0] = Queen.new('White')
      board.grid[5][2] = Pawn.new('White')
      result = board.move_piece([7, 0], [4, 3])
      expect(result).to eq(:blocked)
    end

    it 'allows a queen move up-right if clear' do
      board.grid[7][0] = Queen.new('White')
      result = board.move_piece([7, 0], [4, 3])
      expect(result).to eq(:ok)
    end

    # Diagonal ↙
    it 'rejects a queen move down-left when blocked' do
      board.grid[0][7] = Queen.new('White')
      board.grid[2][5] = Pawn.new('White')
      result = board.move_piece([0, 7], [3, 4])
      expect(result).to eq(:blocked)
    end

    it 'allows a queen move down-left if clear' do
      board.grid[0][7] = Queen.new('White')
      result = board.move_piece([0, 7], [3, 4])
      expect(result).to eq(:ok)
    end

    # Diagonal ↖
    it 'rejects a queen move up-left when blocked' do
      board.grid[7][7] = Queen.new('White')
      board.grid[5][5] = Pawn.new('White')
      result = board.move_piece([7, 7], [4, 4])
      expect(result).to eq(:blocked)
    end

    it 'allows a queen move up-left if clear' do
      board.grid[7][7] = Queen.new('White')
      result = board.move_piece([7, 7], [4, 4])
      expect(result).to eq(:ok)
    end
  end

  describe '#move_piece with Pawn blockers' do
    before(:each) { board.grid = Array.new(8) { Array.new(8) } }

    context 'white pawns' do
      it 'rejects a one-square forward move if the square is occupied' do
        board.grid[6][4] = Pawn.new('White') # e2
        board.grid[5][4] = Pawn.new('White') # blocking at e3

        result = board.move_piece([6, 4], [5, 4])
        expect(result).to eq(:blocked)
        expect(board.grid[6][4]).to be_a(Pawn)
        expect(board.grid[5][4]).to be_a(Pawn)
      end

      it 'rejects a two-square forward move if the immediate square is occupied' do
        board.grid[6][4] = Pawn.new('White')
        board.grid[5][4] = Pawn.new('Black') # blocking at e3

        result = board.move_piece([6, 4], [4, 4]) # e2 → e4
        expect(result).to eq(:blocked)
        expect(board.grid[6][4]).to be_a(Pawn)
        expect(board.grid[4][4]).to be_nil
      end

      it 'rejects a two-square forward move if the destination square is occupied' do
        board.grid[6][4] = Pawn.new('White')
        board.grid[4][4] = Pawn.new('Black') # blocking at e4

        result = board.move_piece([6, 4], [4, 4]) # e2 → e4
        expect(result).to eq(:blocked)
        expect(board.grid[6][4]).to be_a(Pawn)
        expect(board.grid[4][4]).to be_a(Pawn)
      end

      it 'allows a two-square forward move if both squares are clear' do
        board.grid[6][4] = Pawn.new('White')

        result = board.move_piece([6, 4], [4, 4]) # e2 → e4
        expect(result).to eq(:ok)
        expect(board.grid[4][4]).to be_a(Pawn)
        expect(board.grid[6][4]).to be_nil
      end
    end

    context 'black pawns' do
      it 'rejects a one-square forward move if the square is occupied' do
        board.grid[1][4] = Pawn.new('Black') # e7
        board.grid[2][4] = Pawn.new('Black') # blocking at e6

        result = board.move_piece([1, 4], [2, 4])
        expect(result).to eq(:blocked)
        expect(board.grid[1][4]).to be_a(Pawn)
        expect(board.grid[2][4]).to be_a(Pawn)
      end

      it 'rejects a two-square forward move if the immediate square is occupied' do
        board.grid[1][4] = Pawn.new('Black')
        board.grid[2][4] = Pawn.new('White') # blocking at e6

        result = board.move_piece([1, 4], [3, 4]) # e7 → e5
        expect(result).to eq(:blocked)
        expect(board.grid[1][4]).to be_a(Pawn)
        expect(board.grid[3][4]).to be_nil
      end

      it 'rejects a two-square forward move if the destination square is occupied' do
        board.grid[1][4] = Pawn.new('Black')
        board.grid[3][4] = Pawn.new('White') # blocking at e5

        result = board.move_piece([1, 4], [3, 4]) # e7 → e5
        expect(result).to eq(:blocked)
        expect(board.grid[1][4]).to be_a(Pawn)
        expect(board.grid[3][4]).to be_a(Pawn)
      end

      it 'allows a two-square forward move if both squares are clear' do
        board.grid[1][4] = Pawn.new('Black')

        result = board.move_piece([1, 4], [3, 4]) # e7 → e5
        expect(result).to eq(:ok)
        expect(board.grid[3][4]).to be_a(Pawn)
        expect(board.grid[1][4]).to be_nil
      end
    end
  end

  describe '#move_piece with Rook captures' do
    before(:each) { board.grid = Array.new(8) { Array.new(8) } }

    context 'White rook capturing Black pieces' do
      it 'captures upward' do
        board.grid[4][4] = Rook.new('White')
        board.grid[1][4] = Pawn.new('Black')

        result = board.move_piece([4, 4], [1, 4])
        expect(result).to eq(:capture)
        expect(board.grid[1][4]).to be_a(Rook)
        expect(board.grid[1][4].color).to eq('White')
        expect(board.grid[4][4]).to be_nil
      end

      it 'captures downward' do
        board.grid[4][4] = Rook.new('White')
        board.grid[6][4] = Pawn.new('Black')

        result = board.move_piece([4, 4], [6, 4])
        expect(result).to eq(:capture)
        expect(board.grid[6][4]).to be_a(Rook)
        expect(board.grid[6][4].color).to eq('White')
        expect(board.grid[4][4]).to be_nil
      end

      it 'captures left' do
        board.grid[4][4] = Rook.new('White')
        board.grid[4][1] = Pawn.new('Black')

        result = board.move_piece([4, 4], [4, 1])
        expect(result).to eq(:capture)
        expect(board.grid[4][1]).to be_a(Rook)
        expect(board.grid[4][1].color).to eq('White')
        expect(board.grid[4][4]).to be_nil
      end

      it 'captures right' do
        board.grid[4][4] = Rook.new('White')
        board.grid[4][7] = Pawn.new('Black')

        result = board.move_piece([4, 4], [4, 7])
        expect(result).to eq(:capture)
        expect(board.grid[4][7]).to be_a(Rook)
        expect(board.grid[4][7].color).to eq('White')
        expect(board.grid[4][4]).to be_nil
      end
    end

    context 'Black rook capturing White pieces' do
      it 'captures upward' do
        board.grid[4][4] = Rook.new('Black')
        board.grid[1][4] = Pawn.new('White')

        result = board.move_piece([4, 4], [1, 4])
        expect(result).to eq(:capture)
        expect(board.grid[1][4]).to be_a(Rook)
        expect(board.grid[1][4].color).to eq('Black')
        expect(board.grid[4][4]).to be_nil
      end

      it 'captures downward' do
        board.grid[4][4] = Rook.new('Black')
        board.grid[6][4] = Pawn.new('White')

        result = board.move_piece([4, 4], [6, 4])
        expect(result).to eq(:capture)
        expect(board.grid[6][4]).to be_a(Rook)
        expect(board.grid[6][4].color).to eq('Black')
        expect(board.grid[4][4]).to be_nil
      end

      it 'captures left' do
        board.grid[4][4] = Rook.new('Black')
        board.grid[4][1] = Pawn.new('White')

        result = board.move_piece([4, 4], [4, 1])
        expect(result).to eq(:capture)
        expect(board.grid[4][1]).to be_a(Rook)
        expect(board.grid[4][1].color).to eq('Black')
        expect(board.grid[4][4]).to be_nil
      end

      it 'captures right' do
        board.grid[4][4] = Rook.new('Black')
        board.grid[4][7] = Pawn.new('White')

        result = board.move_piece([4, 4], [4, 7])
        expect(result).to eq(:capture)
        expect(board.grid[4][7]).to be_a(Rook)
        expect(board.grid[4][7].color).to eq('Black')
        expect(board.grid[4][4]).to be_nil
      end
    end
  end

  describe '#move_piece when destination occupied by same color' do
    before(:each) { board.grid = Array.new(8) { Array.new(8) } }

    context 'White pieces' do
      it 'rejects rook moving onto same-color piece' do
        board.grid[0][0] = Rook.new('White')
        board.grid[0][7] = Pawn.new('White')
        result = board.move_piece([0, 0], [0, 7])
        expect(result).to eq(:blocked)
      end

      it 'rejects bishop moving onto same-color piece' do
        board.grid[0][0] = Bishop.new('White')
        board.grid[3][3] = Pawn.new('White')
        result = board.move_piece([0, 0], [3, 3])
        expect(result).to eq(:blocked)
      end

      it 'rejects queen moving onto same-color piece' do
        board.grid[0][0] = Queen.new('White')
        board.grid[0][5] = Pawn.new('White')
        result = board.move_piece([0, 0], [0, 5])
        expect(result).to eq(:blocked)
      end

      it 'rejects knight moving onto same-color piece' do
        board.grid[4][4] = Knight.new('White')
        board.grid[6][5] = Pawn.new('White')
        result = board.move_piece([4, 4], [6, 5])
        expect(result).to eq(:blocked)
      end

      it 'rejects king moving onto same-color piece' do
        board.grid[4][4] = King.new('White')
        board.grid[5][5] = Pawn.new('White')
        result = board.move_piece([4, 4], [5, 5])
        expect(result).to eq(:blocked)
      end

      it 'rejects pawn moving forward onto same-color piece' do
        board.grid[6][4] = Pawn.new('White')
        board.grid[5][4] = Pawn.new('White')
        result = board.move_piece([6, 4], [5, 4])
        expect(result).to eq(:blocked)
      end
    end

    context 'Black pieces' do
      it 'rejects rook moving onto same-color piece' do
        board.grid[0][0] = Rook.new('Black')
        board.grid[0][7] = Pawn.new('Black')
        result = board.move_piece([0, 0], [0, 7])
        expect(result).to eq(:blocked)
      end

      it 'rejects bishop moving onto same-color piece' do
        board.grid[0][0] = Bishop.new('Black')
        board.grid[3][3] = Pawn.new('Black')
        result = board.move_piece([0, 0], [3, 3])
        expect(result).to eq(:blocked)
      end

      it 'rejects queen moving onto same-color piece' do
        board.grid[0][0] = Queen.new('Black')
        board.grid[0][5] = Pawn.new('Black')
        result = board.move_piece([0, 0], [0, 5])
        expect(result).to eq(:blocked)
      end

      it 'rejects knight moving onto same-color piece' do
        board.grid[4][4] = Knight.new('Black')
        board.grid[6][5] = Pawn.new('Black')
        result = board.move_piece([4, 4], [6, 5])
        expect(result).to eq(:blocked)
      end

      it 'rejects king moving onto same-color piece' do
        board.grid[4][4] = King.new('Black')
        board.grid[5][5] = Pawn.new('Black')
        result = board.move_piece([4, 4], [5, 5])
        expect(result).to eq(:blocked)
      end

      it 'rejects pawn moving forward onto same-color piece' do
        board.grid[1][4] = Pawn.new('Black')
        board.grid[2][4] = Pawn.new('Black')
        result = board.move_piece([1, 4], [2, 4])
        expect(result).to eq(:blocked)
      end
    end
  end

  describe '#move_piece with Bishop captures' do
    before(:each) { board.grid = Array.new(8) { Array.new(8) } }

    context 'White bishop capturing Black pieces' do
      it 'captures up-right' do
        board.grid[4][4] = Bishop.new('White')
        board.grid[6][6] = Pawn.new('Black')

        result = board.move_piece([4, 4], [6, 6])
        expect(result).to eq(:capture)
        expect(board.grid[6][6]).to be_a(Bishop)
        expect(board.grid[6][6].color).to eq('White')
        expect(board.grid[4][4]).to be_nil
      end

      it 'captures up-left' do
        board.grid[4][4] = Bishop.new('White')
        board.grid[6][2] = Pawn.new('Black')

        result = board.move_piece([4, 4], [6, 2])
        expect(result).to eq(:capture)
        expect(board.grid[6][2]).to be_a(Bishop)
        expect(board.grid[6][2].color).to eq('White')
        expect(board.grid[4][4]).to be_nil
      end

      it 'captures down-right' do
        board.grid[4][4] = Bishop.new('White')
        board.grid[2][6] = Pawn.new('Black')

        result = board.move_piece([4, 4], [2, 6])
        expect(result).to eq(:capture)
        expect(board.grid[2][6]).to be_a(Bishop)
        expect(board.grid[2][6].color).to eq('White')
        expect(board.grid[4][4]).to be_nil
      end

      it 'captures down-left' do
        board.grid[4][4] = Bishop.new('White')
        board.grid[2][2] = Pawn.new('Black')

        result = board.move_piece([4, 4], [2, 2])
        expect(result).to eq(:capture)
        expect(board.grid[2][2]).to be_a(Bishop)
        expect(board.grid[2][2].color).to eq('White')
        expect(board.grid[4][4]).to be_nil
      end
    end

    context 'Black bishop capturing White pieces' do
      it 'captures up-right' do
        board.grid[4][4] = Bishop.new('Black')
        board.grid[6][6] = Pawn.new('White')

        result = board.move_piece([4, 4], [6, 6])
        expect(result).to eq(:capture)
        expect(board.grid[6][6]).to be_a(Bishop)
        expect(board.grid[6][6].color).to eq('Black')
        expect(board.grid[4][4]).to be_nil
      end

      it 'captures up-left' do
        board.grid[4][4] = Bishop.new('Black')
        board.grid[6][2] = Pawn.new('White')

        result = board.move_piece([4, 4], [6, 2])
        expect(result).to eq(:capture)
        expect(board.grid[6][2]).to be_a(Bishop)
        expect(board.grid[6][2].color).to eq('Black')
        expect(board.grid[4][4]).to be_nil
      end

      it 'captures down-right' do
        board.grid[4][4] = Bishop.new('Black')
        board.grid[2][6] = Pawn.new('White')

        result = board.move_piece([4, 4], [2, 6])
        expect(result).to eq(:capture)
        expect(board.grid[2][6]).to be_a(Bishop)
        expect(board.grid[2][6].color).to eq('Black')
        expect(board.grid[4][4]).to be_nil
      end

      it 'captures down-left' do
        board.grid[4][4] = Bishop.new('Black')
        board.grid[2][2] = Pawn.new('White')

        result = board.move_piece([4, 4], [2, 2])
        expect(result).to eq(:capture)
        expect(board.grid[2][2]).to be_a(Bishop)
        expect(board.grid[2][2].color).to eq('Black')
        expect(board.grid[4][4]).to be_nil
      end
    end
  end

  describe '#move_piece with Queen captures' do
    before(:each) { board.grid = Array.new(8) { Array.new(8) } }

    context 'White queen capturing Black pieces' do
      it 'captures up' do
        board.grid[4][4] = Queen.new('White')
        board.grid[1][4] = Pawn.new('Black')

        result = board.move_piece([4, 4], [1, 4])
        expect(result).to eq(:capture)
        expect(board.grid[1][4]).to be_a(Queen)
        expect(board.grid[1][4].color).to eq('White')
        expect(board.grid[4][4]).to be_nil
      end

      it 'captures down' do
        board.grid[4][4] = Queen.new('White')
        board.grid[6][4] = Pawn.new('Black')

        result = board.move_piece([4, 4], [6, 4])
        expect(result).to eq(:capture)
        expect(board.grid[6][4]).to be_a(Queen)
        expect(board.grid[6][4].color).to eq('White')
        expect(board.grid[4][4]).to be_nil
      end

      it 'captures left' do
        board.grid[4][4] = Queen.new('White')
        board.grid[4][1] = Pawn.new('Black')

        result = board.move_piece([4, 4], [4, 1])
        expect(result).to eq(:capture)
        expect(board.grid[4][1]).to be_a(Queen)
        expect(board.grid[4][1].color).to eq('White')
        expect(board.grid[4][4]).to be_nil
      end

      it 'captures right' do
        board.grid[4][4] = Queen.new('White')
        board.grid[4][7] = Pawn.new('Black')

        result = board.move_piece([4, 4], [4, 7])
        expect(result).to eq(:capture)
        expect(board.grid[4][7]).to be_a(Queen)
        expect(board.grid[4][7].color).to eq('White')
        expect(board.grid[4][4]).to be_nil
      end

      it 'captures up-right' do
        board.grid[4][4] = Queen.new('White')
        board.grid[6][6] = Pawn.new('Black')

        result = board.move_piece([4, 4], [6, 6])
        expect(result).to eq(:capture)
        expect(board.grid[6][6]).to be_a(Queen)
        expect(board.grid[6][6].color).to eq('White')
        expect(board.grid[4][4]).to be_nil
      end

      it 'captures up-left' do
        board.grid[4][4] = Queen.new('White')
        board.grid[6][2] = Pawn.new('Black')

        result = board.move_piece([4, 4], [6, 2])
        expect(result).to eq(:capture)
        expect(board.grid[6][2]).to be_a(Queen)
        expect(board.grid[6][2].color).to eq('White')
        expect(board.grid[4][4]).to be_nil
      end

      it 'captures down-right' do
        board.grid[4][4] = Queen.new('White')
        board.grid[2][6] = Pawn.new('Black')

        result = board.move_piece([4, 4], [2, 6])
        expect(result).to eq(:capture)
        expect(board.grid[2][6]).to be_a(Queen)
        expect(board.grid[2][6].color).to eq('White')
        expect(board.grid[4][4]).to be_nil
      end

      it 'captures down-left' do
        board.grid[4][4] = Queen.new('White')
        board.grid[2][2] = Pawn.new('Black')

        result = board.move_piece([4, 4], [2, 2])
        expect(result).to eq(:capture)
        expect(board.grid[2][2]).to be_a(Queen)
        expect(board.grid[2][2].color).to eq('White')
        expect(board.grid[4][4]).to be_nil
      end
    end

    context 'Black queen capturing White pieces' do
      it 'captures up' do
        board.grid[4][4] = Queen.new('Black')
        board.grid[1][4] = Pawn.new('White')

        result = board.move_piece([4, 4], [1, 4])
        expect(result).to eq(:capture)
        expect(board.grid[1][4]).to be_a(Queen)
        expect(board.grid[1][4].color).to eq('Black')
        expect(board.grid[4][4]).to be_nil
      end

      it 'captures down' do
        board.grid[4][4] = Queen.new('Black')
        board.grid[6][4] = Pawn.new('White')

        result = board.move_piece([4, 4], [6, 4])
        expect(result).to eq(:capture)
        expect(board.grid[6][4]).to be_a(Queen)
        expect(board.grid[6][4].color).to eq('Black')
        expect(board.grid[4][4]).to be_nil
      end

      it 'captures left' do
        board.grid[4][4] = Queen.new('Black')
        board.grid[4][1] = Pawn.new('White')

        result = board.move_piece([4, 4], [4, 1])
        expect(result).to eq(:capture)
        expect(board.grid[4][1]).to be_a(Queen)
        expect(board.grid[4][1].color).to eq('Black')
        expect(board.grid[4][4]).to be_nil
      end

      it 'captures right' do
        board.grid[4][4] = Queen.new('Black')
        board.grid[4][7] = Pawn.new('White')

        result = board.move_piece([4, 4], [4, 7])
        expect(result).to eq(:capture)
        expect(board.grid[4][7]).to be_a(Queen)
        expect(board.grid[4][7].color).to eq('Black')
        expect(board.grid[4][4]).to be_nil
      end

      it 'captures up-right' do
        board.grid[4][4] = Queen.new('Black')
        board.grid[6][6] = Pawn.new('White')

        result = board.move_piece([4, 4], [6, 6])
        expect(result).to eq(:capture)
        expect(board.grid[6][6]).to be_a(Queen)
        expect(board.grid[6][6].color).to eq('Black')
        expect(board.grid[4][4]).to be_nil
      end

      it 'captures up-left' do
        board.grid[4][4] = Queen.new('Black')
        board.grid[6][2] = Pawn.new('White')

        result = board.move_piece([4, 4], [6, 2])
        expect(result).to eq(:capture)
        expect(board.grid[6][2]).to be_a(Queen)
        expect(board.grid[6][2].color).to eq('Black')
        expect(board.grid[4][4]).to be_nil
      end

      it 'captures down-right' do
        board.grid[4][4] = Queen.new('Black')
        board.grid[2][6] = Pawn.new('White')

        result = board.move_piece([4, 4], [2, 6])
        expect(result).to eq(:capture)
        expect(board.grid[2][6]).to be_a(Queen)
        expect(board.grid[2][6].color).to eq('Black')
        expect(board.grid[4][4]).to be_nil
      end

      it 'captures down-left' do
        board.grid[4][4] = Queen.new('Black')
        board.grid[2][2] = Pawn.new('White')

        result = board.move_piece([4, 4], [2, 2])
        expect(result).to eq(:capture)
        expect(board.grid[2][2]).to be_a(Queen)
        expect(board.grid[2][2].color).to eq('Black')
        expect(board.grid[4][4]).to be_nil
      end
    end
  end

  describe '#move_piece with King captures' do
    before(:each) { board.grid = Array.new(8) { Array.new(8) } }

    context 'White king capturing Black pieces' do
      it 'captures upward' do
        board.grid[4][4] = King.new('White')
        board.grid[3][4] = Pawn.new('Black')

        result = board.move_piece([4, 4], [3, 4])
        expect(result).to eq(:capture)
        expect(board.grid[3][4]).to be_a(King)
        expect(board.grid[3][4].color).to eq('White')
        expect(board.grid[4][4]).to be_nil
      end

      it 'captures downward' do
        board.grid[4][4] = King.new('White')
        board.grid[5][4] = Pawn.new('Black')

        result = board.move_piece([4, 4], [5, 4])
        expect(result).to eq(:capture)
        expect(board.grid[5][4]).to be_a(King)
        expect(board.grid[5][4].color).to eq('White')
        expect(board.grid[4][4]).to be_nil
      end

      it 'captures left' do
        board.grid[4][4] = King.new('White')
        board.grid[4][3] = Pawn.new('Black')

        result = board.move_piece([4, 4], [4, 3])
        expect(result).to eq(:capture)
        expect(board.grid[4][3]).to be_a(King)
        expect(board.grid[4][3].color).to eq('White')
        expect(board.grid[4][4]).to be_nil
      end

      it 'captures right' do
        board.grid[4][4] = King.new('White')
        board.grid[4][5] = Pawn.new('Black')

        result = board.move_piece([4, 4], [4, 5])
        expect(result).to eq(:capture)
        expect(board.grid[4][5]).to be_a(King)
        expect(board.grid[4][5].color).to eq('White')
        expect(board.grid[4][4]).to be_nil
      end

      it 'captures up-left' do
        board.grid[4][4] = King.new('White')
        board.grid[3][3] = Pawn.new('Black')

        result = board.move_piece([4, 4], [3, 3])
        expect(result).to eq(:capture)
        expect(board.grid[3][3]).to be_a(King)
        expect(board.grid[3][3].color).to eq('White')
        expect(board.grid[4][4]).to be_nil
      end

      it 'captures up-right' do
        board.grid[4][4] = King.new('White')
        board.grid[3][5] = Pawn.new('Black')

        result = board.move_piece([4, 4], [3, 5])
        expect(result).to eq(:capture)
        expect(board.grid[3][5]).to be_a(King)
        expect(board.grid[3][5].color).to eq('White')
        expect(board.grid[4][4]).to be_nil
      end

      it 'captures down-left' do
        board.grid[4][4] = King.new('White')
        board.grid[5][3] = Pawn.new('Black')

        result = board.move_piece([4, 4], [5, 3])
        expect(result).to eq(:capture)
        expect(board.grid[5][3]).to be_a(King)
        expect(board.grid[5][3].color).to eq('White')
        expect(board.grid[4][4]).to be_nil
      end

      it 'captures down-right' do
        board.grid[4][4] = King.new('White')
        board.grid[5][5] = Pawn.new('Black')

        result = board.move_piece([4, 4], [5, 5])
        expect(result).to eq(:capture)
        expect(board.grid[5][5]).to be_a(King)
        expect(board.grid[5][5].color).to eq('White')
        expect(board.grid[4][4]).to be_nil
      end
    end

    context 'Black king capturing White pieces' do
      it 'captures upward' do
        board.grid[4][4] = King.new('Black')
        board.grid[3][4] = Pawn.new('White')

        result = board.move_piece([4, 4], [3, 4])
        expect(result).to eq(:capture)
        expect(board.grid[3][4]).to be_a(King)
        expect(board.grid[3][4].color).to eq('Black')
        expect(board.grid[4][4]).to be_nil
      end

      # ↓ down
      it 'captures downward' do
        board.grid[4][4] = King.new('Black')
        board.grid[5][4] = Pawn.new('White')

        result = board.move_piece([4, 4], [5, 4])
        expect(result).to eq(:capture)
        expect(board.grid[5][4]).to be_a(King)
        expect(board.grid[5][4].color).to eq('Black')
        expect(board.grid[4][4]).to be_nil
      end

      # ← left
      it 'captures left' do
        board.grid[4][4] = King.new('Black')
        board.grid[4][3] = Pawn.new('White')

        result = board.move_piece([4, 4], [4, 3])
        expect(result).to eq(:capture)
        expect(board.grid[4][3]).to be_a(King)
        expect(board.grid[4][3].color).to eq('Black')
        expect(board.grid[4][4]).to be_nil
      end

      # → right
      it 'captures right' do
        board.grid[4][4] = King.new('Black')
        board.grid[4][5] = Pawn.new('White')

        result = board.move_piece([4, 4], [4, 5])
        expect(result).to eq(:capture)
        expect(board.grid[4][5]).to be_a(King)
        expect(board.grid[4][5].color).to eq('Black')
        expect(board.grid[4][4]).to be_nil
      end

      # ↖ up-left
      it 'captures up-left' do
        board.grid[4][4] = King.new('Black')
        board.grid[3][3] = Pawn.new('White')

        result = board.move_piece([4, 4], [3, 3])
        expect(result).to eq(:capture)
        expect(board.grid[3][3]).to be_a(King)
        expect(board.grid[3][3].color).to eq('Black')
        expect(board.grid[4][4]).to be_nil
      end

      # ↗ up-right
      it 'captures up-right' do
        board.grid[4][4] = King.new('Black')
        board.grid[3][5] = Pawn.new('White')

        result = board.move_piece([4, 4], [3, 5])
        expect(result).to eq(:capture)
        expect(board.grid[3][5]).to be_a(King)
        expect(board.grid[3][5].color).to eq('Black')
        expect(board.grid[4][4]).to be_nil
      end

      # ↙ down-left
      it 'captures down-left' do
        board.grid[4][4] = King.new('Black')
        board.grid[5][3] = Pawn.new('White')

        result = board.move_piece([4, 4], [5, 3])
        expect(result).to eq(:capture)
        expect(board.grid[5][3]).to be_a(King)
        expect(board.grid[5][3].color).to eq('Black')
        expect(board.grid[4][4]).to be_nil
      end

      # ↘ down-right
      it 'captures down-right' do
        board.grid[4][4] = King.new('Black')
        board.grid[5][5] = Pawn.new('White')

        result = board.move_piece([4, 4], [5, 5])
        expect(result).to eq(:capture)
        expect(board.grid[5][5]).to be_a(King)
        expect(board.grid[5][5].color).to eq('Black')
        expect(board.grid[4][4]).to be_nil
      end
    end
  end

  describe '#move_piece with Pawn captures' do
    before(:each) { board.grid = Array.new(8) { Array.new(8) } }

    context 'White pawn capturing' do
      it 'captures diagonally left (up-left)' do
        board.grid[4][4] = Pawn.new('White')
        board.grid[3][3] = Pawn.new('Black')

        result = board.move_piece([4, 4], [3, 3])
        expect(result).to eq(:capture)
        expect(board.grid[3][3]).to be_a(Pawn)
        expect(board.grid[3][3].color).to eq('White')
        expect(board.grid[4][4]).to be_nil
      end

      it 'captures diagonally right (up-right)' do
        board.grid[4][4] = Pawn.new('White')
        board.grid[3][5] = Pawn.new('Black')

        result = board.move_piece([4, 4], [3, 5])
        expect(result).to eq(:capture)
        expect(board.grid[3][5]).to be_a(Pawn)
        expect(board.grid[3][5].color).to eq('White')
        expect(board.grid[4][4]).to be_nil
      end

      it 'rejects capturing diagonally left onto same-color piece' do
        board.grid[4][4] = Pawn.new('White')
        board.grid[3][3] = Pawn.new('White')

        result = board.move_piece([4, 4], [3, 3])
        expect(result).to eq(:blocked)
        expect(board.grid[4][4]).to be_a(Pawn)
        expect(board.grid[3][3]).to be_a(Pawn)
      end

      it 'rejects capturing diagonally right onto same-color piece' do
        board.grid[4][4] = Pawn.new('White')
        board.grid[3][5] = Pawn.new('White')

        result = board.move_piece([4, 4], [3, 5])
        expect(result).to eq(:blocked)
        expect(board.grid[4][4]).to be_a(Pawn)
        expect(board.grid[3][5]).to be_a(Pawn)
      end
    end

    context 'Black pawn capturing' do
      it 'captures diagonally left (down-left)' do
        board.grid[3][3] = Pawn.new('Black')
        board.grid[4][2] = Pawn.new('White')

        result = board.move_piece([3, 3], [4, 2])
        expect(result).to eq(:capture)
        expect(board.grid[4][2]).to be_a(Pawn)
        expect(board.grid[4][2].color).to eq('Black')
        expect(board.grid[3][3]).to be_nil
      end

      it 'captures diagonally right (down-right)' do
        board.grid[3][3] = Pawn.new('Black')
        board.grid[4][4] = Pawn.new('White')

        result = board.move_piece([3, 3], [4, 4])
        expect(result).to eq(:capture)
        expect(board.grid[4][4]).to be_a(Pawn)
        expect(board.grid[4][4].color).to eq('Black')
        expect(board.grid[3][3]).to be_nil
      end

      it 'rejects capturing diagonally left onto same-color piece' do
        board.grid[3][3] = Pawn.new('Black')
        board.grid[4][2] = Pawn.new('Black')

        result = board.move_piece([3, 3], [4, 2])
        expect(result).to eq(:blocked)
        expect(board.grid[3][3]).to be_a(Pawn)
        expect(board.grid[4][2]).to be_a(Pawn)
      end

      it 'rejects capturing diagonally right onto same-color piece' do
        board.grid[3][3] = Pawn.new('Black')
        board.grid[4][4] = Pawn.new('Black')

        result = board.move_piece([3, 3], [4, 4])
        expect(result).to eq(:blocked)
        expect(board.grid[3][3]).to be_a(Pawn)
        expect(board.grid[4][4]).to be_a(Pawn)
      end
    end
  end
end
