# spec/view_spec.rb
require 'spec_helper'
require_relative '../lib/view'
require_relative '../lib/board'
require_relative '../lib/pawn'

RSpec.describe View do
  let(:view) { View.new }

  describe '#welcome' do
    it 'prints the welcome message' do
      expect { view.welcome }.to output("Welcome to Chess!\n").to_stdout
    end
  end

  describe '#show_turn' do
    it 'prints whose turn it is' do
      expect { view.show_turn('White') }.to output("It is White's turn\n").to_stdout
      expect { view.show_turn('Black') }.to output("It is Black's turn\n").to_stdout
    end
  end

  describe '#show_board' do
    let(:board) { Board.new }

    it 'prints an 8x8 grid of underscores' do
      expect { view.show_board(board.grid) }.to output(/_ _ _ _ _ _ _ _/).to_stdout
    end

    it 'prints row labels 1 and 8 on the left side' do
      expect { view.show_board(board.grid) }.to output(/1 _ _ _ _ _ _ _ _/).to_stdout
      expect { view.show_board(board.grid) }.to output(/8 _ _ _ _ _ _ _ _/).to_stdout
    end

    it 'prints column labels a–h on the bottom' do
      expect { view.show_board(board.grid) }.to output(/a b c d e f g h\n/).to_stdout
    end

    it 'renders a white pawn at the correct spot (a2)' do
      pawn = Pawn.new('White')
      board.grid[6][0] = pawn

      expected_row = "2 WP _ _ _ _ _ _ _\n" # row label + WP in col a
      expect { view.show_board(board.grid) }.to output(/#{Regexp.escape(expected_row)}/).to_stdout
    end

    it 'prints the initial chess setup' do
      board.setup_board
      expected_output = <<~BOARD
        8 BR BN BB BQ BK BB BN BR
        7 BP BP BP BP BP BP BP BP
        6 _ _ _ _ _ _ _ _
        5 _ _ _ _ _ _ _ _
        4 _ _ _ _ _ _ _ _
        3 _ _ _ _ _ _ _ _
        2 WP WP WP WP WP WP WP WP
        1 WR WN WB WQ WK WB WN WR
          a b c d e f g h
      BOARD

      expect { view.show_board(board.grid) }.to output(expected_output).to_stdout
    end
  end
end
