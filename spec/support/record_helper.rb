module RecordHelper
  RECORD_NAMES = %w{family kit library variation}
  PLURAL_RECORD_NAMES = %w{families kits libraries variations}

  def record_names
    RECORD_NAMES
  end

  def record_symbols
    @record_symbols ||= record_names.map(&:to_sym)
  end

  def record_classes
    @record_classes ||= record_names.map do |name|
      Typekit::Record.const_get(name.capitalize)
    end
  end

  def record_dictionary
    @record_dictionary ||= Hash[
      record_symbols.clone.zip(record_classes)
    ]
  end

  def plural_record_names
    PLURAL_RECORD_NAMES
  end

  def plural_record_symbols
    @plural_record_symbols ||= plural_record_names.map(&:to_sym)
  end

  def plural_record_dictionary
    @plural_record_dictionary ||= Hash[
      plural_record_symbols.clone.zip(record_classes)
    ]
  end
end
