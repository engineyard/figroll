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

  describe '.configure' do
    let(:filename) {'figroll.yml'}
    let(:config_file) {
      File.join(MOCK_PATH, filename)
    }

    let(:configure) {described_class.configure(config_file)}

    before(:each) do
      storage.send(:reset)
      config.send(:reset)
    end

    it 'loads the config file via a config object' do
      expect(config).
        to receive(:load_file).
        with(config_file)

      configure
    end

    context 'when there is an applicable configuration environment' do
      let(:filename) {'withoutreqs.yml'}

      it 'imports the configuration environment' do
        expect(storage).
          to receive(:import).
          with({'SAUSAGES' => 'gold'})

        configure
      end
    end

    it 'imports the execution environment' do
      expect(storage).
        to receive(:import).
        with(ENV)

      configure
    end

    context 'when there are required variables' do
      let(:filename) {'withreqs.yml'}
  
      context 'but there is a missing required variable' do
        before(:each) do
          ENV.delete('SAUSAGES')
        end

        it 'raises an error' do
          expect {configure}.to raise_error("Required variables not set: SAUSAGES")
        end
      end

      context 'multiple missing required variables' do
        let(:filename) {'multireqs.yml'}

        before(:each) do
          ENV.delete('SAUSAGES')
          ENV.delete('GOLDERBLATS')
        end

        it 'raises an error' do
          expect {configure}.to raise_error("Required variables not set: GOLDERBLATS, SAUSAGES")
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
          expect(configure).to eql(nil)
        end
      end
    end

    context 'when there are not required variables' do
      let(:filename) {'withoutreqs.yml'}

      it 'returns nil' do
        expect(configure).to eql(nil)
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
