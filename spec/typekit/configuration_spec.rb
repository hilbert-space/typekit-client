require 'spec_helper'
require 'typekit'

describe Typekit::Configuration do
  let(:subject_module) { Typekit::Configuration }

  def build(name, **options)
    subject_module.build(name, **options)
  end

  describe '.build' do
    it 'requies an API token to be given' do
      expect { build(:default) }.to \
        raise_error(subject_module::Error, /Not enough arguments/i)
    end

    it 'returns registeries of settings' do
      expect(build(:default, token: 'nekot')).to \
        be_kind_of(subject_module::Base)
    end

    it 'raises exceptions when encouters unknown registeries' do
      expect { build(:awesome, token: 'nekot') }.to \
        raise_error(subject_module::Error, /Unknown configuration/i)
    end
  end

  describe 'Base' do
    describe '#mapper' do
      it 'returns a Mapper' do
        expect(build(:default, token: 'nekot').mapper).to \
          be_kind_of(Typekit::Routing::Mapper)
      end
    end

    describe '#dispatcher' do
      it 'returns a Dispatcher' do
        expect(build(:default, token: 'nekot').dispatcher).to \
          be_kind_of(Typekit::Connection::Dispatcher)
      end
    end

    describe '#translator' do
      it 'returns a Translator' do
        expect(build(:default, token: 'nekot').translator).to \
          be_kind_of(Typekit::Processing::Translator)
      end
    end
  end
end
