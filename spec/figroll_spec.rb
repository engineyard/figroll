require 'spec_helper'

describe Figroll do
  let(:storage) {described_class::Storage.new}
  let(:config) {described_class::Config.new}

  before(:each) do
    allow(described_class).to receive(:storage).and_return(storage)
    allow(described_class).to receive(:config).and_return(config)
    allow(described_class).to receive(:reset).and_return(true)

    allow(storage).to receive(:import).and_call_original
  end

  describe '.load_file' do
    let(:filename) {'figroll.yml'}
    let(:config_file) {
      File.join(MOCK_PATH, filename)
    }

    let(:load_file) {described_class.load_file(config_file)}

    before(:each) do
      storage.send(:reset)
      config.send(:reset)
    end

    it 'forwards the call to a config object' do
      expect(described_class.config).to eql(config)
      expect(config).
        to receive(:load_file).
        with(config_file)

      load_file
    end

    context 'when there is an applicable configuration environment' do
      let(:filename) {'withoutreqs.yml'}

      it 'imports the configuration environment' do
        expect(storage).
          to receive(:import).
          with({'SAUSAGES' => 'gold'})

        load_file
      end
    end

    it 'imports the execution environment' do
      expect(storage).
        to receive(:import).
        with(ENV)

      load_file
    end

    context 'when there are required variables' do
      let(:filename) {'withreqs.yml'}
  
      context 'but there is a missing required variable' do
        before(:each) do
          ENV.delete('SAUSAGES')
        end

        it 'raises an error' do
          expect {load_file}.to raise_error("Required variables not set: SAUSAGES")
        end
      end

      context 'multiple missing required variables' do
        let(:filename) {'multireqs.yml'}

        before(:each) do
          ENV.delete('SAUSAGES')
          ENV.delete('GOLDERBLATS')
        end

        it 'raises an error' do
          expect {load_file}.to raise_error("Required variables not set: GOLDERBLATS, SAUSAGES")
        end

      end


      context 'and they are all present' do
        before(:each) do
          ENV['SAUSAGES'] = 'gold'
        end

        after(:each) do
          ENV.delete('SAUSAGES')
        end

        it 'returns nil' do
          expect(load_file).to eql(nil)
        end
      end
    end

    context 'when there are not required variables' do
      let(:filename) {'withoutreqs.yml'}

      it 'returns nil' do
        expect(load_file).to eql(nil)
      end
    end

  end

  describe '.fetch' do
    let(:key) {:whatever}
    let(:value) {'yassss'}

    let(:fetch) {described_class.fetch(key)}

    it 'forwards the call to a storage object' do
      expect(storage).to receive(:fetch).with(key).and_return(value)

      expect(fetch).to eql(value)
    end
  end

end
