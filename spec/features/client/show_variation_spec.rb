require 'spec_helper'

RSpec.describe 'Client#show a variation' do
  let(:subject) { Typekit::Client.new(token: token) }

  options = { vcr: { cassette_name: 'show_families_xxx_yyy_ok' } }

  let(:result) { subject.show(:families, 'xxx', 'yyy') }

  it 'returns a Variation', options do
    expect(result).to be_kind_of(Typekit::Resource::Variation)
  end

  it 'returns a Variation with Libraries', options do
    expect(result.libraries.map(&:class).uniq).to \
      contain_exactly(Typekit::Resource::Library)
  end

  it 'returns a Variation with a Family', options do
    expect(result.family).to be_kind_of(Typekit::Resource::Family)
  end
end
