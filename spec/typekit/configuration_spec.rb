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

  describe 'Base#map' do
    it 'returns a Map' do
      expect(build(:default, token: 'nekot').map).to \
        be_kind_of(Typekit::Routing::Map)
    end
  end
end
