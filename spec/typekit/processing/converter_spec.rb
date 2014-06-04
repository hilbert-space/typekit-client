require 'spec_helper'

RSpec.describe Typekit::Processing::Converter do
  def create(name)
    Typekit::Processing::Converter.build(name)
  end

  let(:request) { double(code: 200) }

  describe '.build#process' do
    %w{family kit library}.each do |name|
      it "maps '#{ name }' to a Record" do
        result = create(name).process(request, {})
        expect(result).to be_kind_of(Typekit::Record::Base)
      end
    end

    %w{families kits libraries}.each do |name|
      it "maps '#{ name }' to an array of Records" do
        result = create(name).process(request, [ {} ])
        result.each { |r| expect(r).to be_kind_of(Typekit::Record::Base) }
      end
    end

    %w{ok}.each do |name|
      it "maps '#{ name }' to a boolean" do
        result = create(name).process(request, true)
        expect(result).to be_kind_of(::TrueClass)
      end
    end

    %w{published}.each do |name|
      it "maps '#{ name }' to a datetime" do
        result = create(name).process(request, '2010-05-20T21:15:31Z')
        expect(result).to be_kind_of(::DateTime)
      end
    end

    [ nil, 'errors' ].each do |name|
      it "raises an exception for '#{ name }'" do
        expect { create(name).process(request, nil) }.to \
          raise_error(Typekit::Processing::Error)
      end
    end

    %w{kittens puppies}.each do |name|
      it "returns unknowns like '#{ name }' as they are" do
        result = create(name).process(request, 42)
        expect(result).to eq(name => 42)
      end
    end
  end
end
