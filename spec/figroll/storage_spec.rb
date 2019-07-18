require 'spec_helper'

describe Figroll::Storage do
  let(:storage) {described_class.new}

  describe '#fetch' do
    let(:data) {
      {
        'two' => 'one',
        'one' => 'three',
        'i like good' => 'ruby',
        'and' => 'I like dumb memes'
      }
    }

    let(:key) {'two'}
    let(:fetch) {storage.fetch(key)}

    before(:each) do
      storage.send(:reset)
      storage.import(data)
    end

    context 'when I reference a known variable' do
      let(:expected) {'ruby'}

      context 'in standard env var format' do
        let(:key) {'I_LIKE_GOOD'}

        it 'is the expected value' do
          expect(fetch).to eql(expected)
        end
      end

      context 'in standard symbol format' do
        let(:key) {:i_like_good}

        it 'is the expected value' do
          expect(fetch).to eql(expected)
        end
      end

      context 'in a conversational manner' do
        let(:key) {'I like good'}

        it 'is the expected value' do
          expect(fetch).to eql(expected)
        end
      end
    end

    context 'when I reference an unknown variable' do
      let(:key) {:unknown}

      it 'raises an error' do
        expect {fetch}.to raise_error
      end
    end
  end

end
