# frozen_string_literal: true

require_relative '../lib/moves_calculator'
require_relative '../lib/board'

describe MovesCalculator do
  let(:subject) { described_class.new(Board.new) }
  describe '#legal_moves' do
    it 'take coordinates in argument and output legal moves' do
      expect(subject.legal_moves([7, 3])).not_to be_nil
      p subject.legal_moves([7, 1])
    end
  end
end