# frozen_string_literal: true

require_relative '../lib/interface'

describe Interface do
  describe '#welcome' do
    it 'output welcome message' do
      expect(subject).to receive(:puts)
      subject.welcome
    end
  end
  
end