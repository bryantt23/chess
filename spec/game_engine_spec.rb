# spec/game_engine_spec.rb
require 'spec_helper'
require_relative '../lib/board'
require_relative '../lib/game_engine'
require_relative '../lib/view'

RSpec.describe GameEngine do
  let(:board) { Board.new }
  let(:view)  { View.new }
  let(:engine) { GameEngine.new(board, view) }

  describe '#new_game' do
    it 'welcomes the player, shows starting board, and sets White to move' do
      allow(engine).to receive(:get_input).and_return('a2 a2')

      expect { engine.new_game }.to output(
        <<~BOARD
          Welcome to Chess!
          8 BR BN BB BQ BK BB BN BR
          7 BP BP BP BP BP BP BP BP
          6 __ __ __ __ __ __ __ __
          5 __ __ __ __ __ __ __ __
          4 __ __ __ __ __ __ __ __
          3 __ __ __ __ __ __ __ __
          2 WP WP WP WP WP WP WP WP
          1 WR WN WB WQ WK WB WN WR
            a  b  c  d  e  f  g  h
          White to move. Enter your move:
        BOARD
      ).to_stdout
    end
  end

  describe '#play_turn' do
    it 'allows White pawn to move and then switches turn to Black' do
      allow(engine).to receive(:get_input).and_return('e2 e4')
      engine.new_game

      expect { engine.play_turn }.to output(
        <<~BOARD
          8 BR BN BB BQ BK BB BN BR
          7 BP BP BP BP BP BP BP BP
          6 __ __ __ __ __ __ __ __
          5 __ __ __ __ __ __ __ __
          4 __ __ __ __ WP __ __ __
          3 __ __ __ __ __ __ __ __
          2 WP WP WP WP __ WP WP WP
          1 WR WN WB WQ WK WB WN WR
            a  b  c  d  e  f  g  h
          Black to move. Enter your move:
        BOARD
      ).to_stdout
    end
  end
end
