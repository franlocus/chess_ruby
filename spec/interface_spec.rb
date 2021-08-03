# frozen_string_literal: true

require_relative '../lib/interface'
require_relative '../lib/colorize'

describe Interface do
  describe '#game_type' do
    context 'outputs welcome message with options to start new game or laod game' do
      context 'user input invalid option, then valid' do
        before do
          allow(subject).to receive(:gets).and_return("25", "1\n")
        end
        it 'puts error once then return game_type 1' do
          expect(subject).to receive(:puts).twice # intruction and error warning 
          expect(subject.game_type).to eq(1)
        end
      end
    end
  end
  describe '#prompt_valid input' do
    before do
      allow(subject).to receive(:puts)
    end
    context 'user input a valid answer and validate correctly' do
      before do
        valid_input = 'a1'
        allow(subject).to receive(:gets).and_return(valid_input)
      end
      it 'returns the input when is a valid algebraic format' do
        expect(subject).to receive(:gets).and_return('a1')
        subject.prompt_valid_input
      end
    end
    context 'user input invalid first and triggers try_again, then a valid' do
      before do
        invalid_input = 'ab1'
        valid_input = 'a1'
        allow(subject).to receive(:gets).and_return(invalid_input, valid_input)
      end
      it 'trigger try_again once when is an invalid algebraic format' do
        expect(subject).to receive(:gets).twice
        expect(subject).to receive(:puts).exactly(3) # Intructions, error, intructions
        subject.prompt_valid_input
      end
    end
  end
end