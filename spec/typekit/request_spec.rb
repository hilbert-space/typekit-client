require 'spec_helper'
require 'typekit'

describe Typekit::Request do
  subject { Typekit::Request.new(action: :show) }

  describe '#address' do
    it 'returns the address' do
      [ :kits, 'xxx', :families, 'yyy' ].each { |chunk| subject << chunk }
      expect(subject.address).to eq('kits/xxx/families/yyy')
    end
  end
end
