require 'spec_helper'
require 'typekit'

describe Typekit::Dictionary do
  WORDS = %w{kit kits family families errors}

  let(:subject_class) { Typekit::Dictionary }

  describe '.lookup' do
    WORDS.each do |word|
      it "knows the word #{ word }" do
        expect { subject_class.lookup(word) }.not_to raise_error
      end
    end

    it 'does not know the word impossible' do
      expect { subject_class.lookup('impossible') }.to \
        raise_error(subject_class::Error)
    end
  end
end
