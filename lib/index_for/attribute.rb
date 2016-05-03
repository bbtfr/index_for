module IndexFor
  module Attribute

    private

    def attribute_value attribute_name, options
      attribute_name = options[:value] if options[:value]
      attribute_name = :"#{attribute_name}.#{options[:with]}" if options[:with]

      parts = attribute_name.to_s.split(".")

      object = @object
      parts.each do |attribute_name|
        object = object.send(attribute_name)
      end
      object
    rescue
      options.key?(:if_raise) ? options[:if_raise] : raise
    end

    def attribute_label attribute_name, options
      return options[:label] if options[:label]
      model_class = options[:model] || html_options[:model] || @object.class
      model_class.human_attribute_name(attribute_name)
    end

  end
end
