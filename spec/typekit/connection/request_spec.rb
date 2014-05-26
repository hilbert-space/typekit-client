require 'spec_helper'
require 'typekit'

describe Typekit::Connection::Request do
  subject { Typekit::Connection::Request.new(action: :show) }

  describe '#address' do
    it 'assembles the address' do
      [ :kits, 'xxx', :families, 'yyy' ].each { |chunk| subject << chunk }
      expect(subject.address).to eq('kits/xxx/families/yyy')
    end
  end
end
