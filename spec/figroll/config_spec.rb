require 'spec_helper'

describe Figroll::Config do
  let(:config) {described_class.new}

  describe '#load_file' do
    let(:filename) {'figroll.yml'}
    let(:config_file) {
      File.join(MOCK_PATH, filename)
    }

    let(:load_file) {config.load_file(config_file)}

    context 'when the file does not exist' do
      let(:filename) {'nosuch.yml'}

      it 'returns nil' do
        expect(load_file).to eql(nil)
      end
    end

    context 'when the file exists' do
      let(:filename) {'figroll.yml'}

      context 'and it contains required variables' do
        let(:filename) {'withreqs.yml'}

        it 'sets up the required variable names' do
          load_file

          expect(config.required).not_to be_empty
        end
      end

      context 'and it contains an applicable environment' do
        let(:filename) {'withoutreqs.yml'}

        it 'sets up the data' do
          load_file
          expect(config.data).not_to be_empty
        end
      end
    end

  end




end
