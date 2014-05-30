require 'spec_helper'
require 'typekit'

describe Typekit::Processing::Converter do
  WORDS = %w{family families kit kits libraries library ok errors}

  let(:subject_class) { Typekit::Processing::Converter }

  describe '.build' do
    WORDS.each do |word|
      it "knows what to do with #{ word }" do
        expect { subject_class.build(word) }.not_to raise_error
      end
    end

    it 'raises expections when encounteres unknown objects' do
      expect { subject_class.build('kittens') }.to \
        raise_error(Typekit::Processing::Error, /Unknown converter/i)
    end
  end
end
