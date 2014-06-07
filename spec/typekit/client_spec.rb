require 'spec_helper'

RSpec.describe Typekit::Client do
  let(:subject) { Typekit::Client.new(token: 'arbitrary') }

  describe '#index kits' do
    context 'when successful' do
      options = { vcr: { cassette_name: 'index_kits_ok' } }

      let(:result) { subject.index(:kits) }

      it 'returns Records', options do
        expect(result.map(&:class).uniq).to \
          contain_exactly(Typekit::Record::Kit)
      end
    end

    context 'when unauthorized' do
      options = { vcr: { cassette_name: 'index_kits_unauthorized' } }

      it 'raises exceptions', options do
        expect { subject.index(:kits) }.to \
          raise_error(Typekit::Processing::Error, /Not authorized/i)
      end
    end
  end

  describe '#show a kit' do
    options = { vcr: { cassette_name: 'show_kits_xxx_ok' } }

    let(:result) { subject.show(:kits, 'xxx') }

    it 'returns a Kit', options do
      expect(result).to be_kind_of(Typekit::Record::Kit)
    end

    it 'returns a Kit with Families', options do
      expect(result.families.map(&:class).uniq).to \
        contain_exactly(Typekit::Record::Family)
    end
  end

  describe '#show a family by its slug' do
    options = { vcr: { cassette_name: 'show_families_xxx_found' } }

    let(:result) { subject.show(:families, 'xxx') }

    it 'returns a Family', options do
      expect(result).to be_kind_of(Typekit::Record::Family)
    end
  end

  shared_examples 'an adequate Family' do |options|
    it 'returns a Family', options do
      expect(result).to be_kind_of(Typekit::Record::Family)
    end

    it 'returns a Family with Variations', options do
      expect(result.variations.map(&:class).uniq).to \
        contain_exactly(Typekit::Record::Variation)
    end
  end

  describe '#show a family' do
    options = { vcr: { cassette_name: 'show_families_xxx_ok' } }

    let(:result) { subject.show(:families, 'xxx') }

    it_behaves_like 'an adequate Family', options

    it 'returns a Family with Libraries', options do
      expect(result.libraries.map(&:class).uniq).to \
        contain_exactly(Typekit::Record::Library)
    end
  end

  describe '#show a family in a kit' do
    options = { vcr: { cassette_name: 'show_kits_xxx_families_yyy_ok' } }

    let(:result) { subject.show(:kits, 'xxx', :families, 'yyy') }

    it_behaves_like 'an adequate Family', options
  end

  describe '#show a variation of a family' do
    options = { vcr: { cassette_name: 'show_families_xxx_yyy_ok' } }

    let(:result) { subject.show(:families, 'xxx', 'yyy') }

    it 'returns a Variation', options do
      expect(result).to be_kind_of(Typekit::Record::Variation)
    end

    it 'returns a Variation with Libraries', options do
      expect(result.libraries.map(&:class).uniq).to \
        contain_exactly(Typekit::Record::Library)
    end

    it 'returns a Variation with a Family', options do
      expect(result.family).to be_kind_of(Typekit::Record::Family)
    end
  end

  describe '#show a library' do
    options = { vcr: { cassette_name: 'show_libraries_xxx_ok' } }

    let(:result) { subject.show(:libraries, 'xxx') }

    it 'returns a Library', options do
      expect(result).to be_kind_of(Typekit::Record::Library)
    end

    it 'returns a Library with Families', options do
      expect(result.families.map(&:class).uniq).to \
        contain_exactly(Typekit::Record::Family)
    end
  end

  describe '#delete a kit' do
    options = { vcr: { cassette_name: 'delete_kits_xxx_ok' } }

    let(:result) { subject.delete(:kits, 'xxx') }

    it 'returns true', options do
      expect(result).to be true
    end
  end
end
