module ResourceHelper
  RESOURCE_NAMES = %w{family kit library variation}
  PLURAL_RESOURCE_NAMES = %w{families kits libraries variations}

  def resource_names
    RESOURCE_NAMES
  end

  def resource_symbols
    @resource_symbols ||= resource_names.map(&:to_sym)
  end

  def resource_classes
    @resource_classes ||= resource_names.map do |name|
      Typekit::Resource.const_get(name.capitalize)
    end
  end

  def resource_dictionary
    @resource_dictionary ||= Hash[
      resource_symbols.clone.zip(resource_classes)
    ]
  end

  def plural_resource_names
    PLURAL_RESOURCE_NAMES
  end

  def plural_resource_symbols
    @plural_resource_symbols ||= plural_resource_names.map(&:to_sym)
  end

  def plural_resource_dictionary
    @plural_resource_dictionary ||= Hash[
      plural_resource_symbols.clone.zip(resource_classes)
    ]
  end
end
