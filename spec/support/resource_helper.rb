module ResourceHelper
  RECORD_NAMES = %w{family kit library variation}
  COLLECTION_NAMES = %w{families kits libraries variations}

  def record_names
    RECORD_CLASS_NAMES
  end

  def record_symbols
    @record_symbols ||= RECORD_NAMES.map(&:to_sym)
  end

  def record_classes
    @record_classes ||= RECORD_NAMES.map do |name|
      Typekit::Record.const_get(name.capitalize)
    end
  end

  def collection_names
    COLLECTION_NAMES
  end

  def collection_symbols
    @collection_symbols ||= COLLECTION_NAMES.map(&:to_sym)
  end

  def record_mapping
    @record_mapping ||= Hash[record_symbols.clone.zip(record_classes)]
  end

  def collection_mapping
    @collection_mapping ||= Hash[collection_symbols.clone.zip(record_classes)]
  end
end
