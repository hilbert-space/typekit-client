require 'rspec/bdd'

RSpec.feature 'Creating a new kit' do
  given(:client) { Typekit::Client.new(token: token) }

  context 'Successful' do
    options = { vcr: { cassette_name: 'create_kits_ok' } }

    scenario 'Using #save', options do
      kit = client::Kit.new(name: 'Megakit', domains: 'localhost')
      kit.save

      expect(kit).to be_persistent
      expect(kit.name).to eq('Megakit')
    end

    scenario 'Using #create', options do
      kit = client::Kit.create(name: 'Megakit', domains: 'localhost')

      expect(kit).to be_persistent
      expect(kit.name).to eq('Megakit')
    end
  end

  context 'Failure' do
    options = { vcr: { cassette_name: 'create_kits_bad' } }

    scenario 'Using #save', options do
      kit = client::Kit.new(name: 'Megakit')

      expect(kit.save).to be false
      expect(kit).not_to be_persistent
    end

    scenario 'Using #save!', options do
      kit = client::Kit.new(name: 'Megakit')

      expect { kit.save! }.to raise_error(Typekit::ServerError)

      expect(kit).to be_new
      expect(kit).not_to be_persistent
    end

    scenario 'Using #create', options do
      kit = client::Kit.create(name: 'Megakit')

      expect(kit).to be_new
      expect(kit).not_to be_persistent
    end
  end
end
