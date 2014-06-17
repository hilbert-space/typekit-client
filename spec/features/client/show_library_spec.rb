require 'spec_helper'

RSpec.describe 'Client#show a library' do
  let(:subject) { Typekit::Client.new(token: token) }

  options = { vcr: { cassette_name: 'show_libraries_xxx_ok' } }

  let(:result) { subject.show(:libraries, 'xxx') }

  it 'returns a Library', options do
    expect(result).to be_kind_of(Typekit::Resource::Library)
  end

  it 'returns a Library with Families', options do
    expect(result.families.map(&:class).uniq).to \
      contain_exactly(Typekit::Resource::Family)
  end
end
