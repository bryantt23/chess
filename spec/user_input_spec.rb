# spec/user_input_spec.rb
require 'spec_helper'
require_relative '../lib/user_input'

RSpec.describe UserInput do
  describe '.valid_input?' do
    # --- Happy path ---
    it 'returns true for valid input a5 b5' do
      expect(UserInput.valid_input?('a5 b5')).to be true
    end

    it 'returns true for all squares a1–h8' do
      ('a'..'h').each do |file|
        (1..8).each do |rank|
          input = "#{file}#{rank} #{file}#{rank}"
          expect(UserInput.valid_input?(input)).to be true
        end
      end
    end

    it 'returns true with extra spaces between inputs' do
      expect(UserInput.valid_input?('a8     b7')).to be true
    end

    it 'returns true for uppercase input' do
      expect(UserInput.valid_input?('A5 B6')).to be true
    end

    # --- Unhappy path ---
    it 'returns false for invalid letters' do
      expect(UserInput.valid_input?('i5 a5')).to be false
      expect(UserInput.valid_input?('z3 h4')).to be false
    end

    it 'returns false for invalid numbers' do
      expect(UserInput.valid_input?('a0 b9')).to be false
      expect(UserInput.valid_input?('a99 h2')).to be false
      expect(UserInput.valid_input?('c-1 d5')).to be false
    end

    it 'returns false for inputs with commas' do
      expect(UserInput.valid_input?('a2, b7')).to be false
    end

    it 'returns false for inputs without a space' do
      expect(UserInput.valid_input?('a2b7')).to be false
    end

    it 'returns false for incomplete input' do
      expect(UserInput.valid_input?('a2')).to be false
      expect(UserInput.valid_input?('a2 ')).to be false
    end

    it 'returns false for gibberish' do
      expect(UserInput.valid_input?('123')).to be false
      expect(UserInput.valid_input?('blah')).to be false
      expect(UserInput.valid_input?('')).to be false
      expect(UserInput.valid_input?('   ')).to be false
    end
  end
end
