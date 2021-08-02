# frozen_string_literal: true

require_relative '../lib_first/moves_calculator'

describe MovesCalculator do
  describe '#legal_moves' do
    it 'take coordinates in argument and output legal moves' do
      expect(subject.legal_moves([6, 2])).not_to be_nil
    end
  end
end