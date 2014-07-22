require 'spec_helper'
require 'rspec/bdd'

RSpec.feature 'Reading a library' do
  given(:client) { Typekit::Client.new(token: token) }

  shared_scenarios 'Adequate behavior' do
    options = { vcr: { cassette_name: 'show_libraries_xxx_ok' } }

    scenario 'Success', options do
      expect(library).to be_kind_of(Typekit::Resource::Library)

      expect(library.families.map(&:class).uniq).to \
        contain_exactly(Typekit::Resource::Family)
    end
  end

  context 'Using Client' do
    given(:library) { client.show(:libraries, 'xxx') }

    include_scenarios 'Adequate behavior'
  end

  context 'Using Resource' do
    given(:library) { client::Library.find('xxx') }

    include_scenarios 'Adequate behavior'
  end
end
