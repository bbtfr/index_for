module IndexFor
  module Attribute

    private

    def attribute_value attribute_name, options
      attribute_name = options[:value] if options[:value]
      attribute_name = :"#{attribute_name}.#{options[:with]}" if options[:with]

      parts = attribute_name.to_s.split(".")
      attribute_name = parts.pop

      object = @object
      parts.each do |attribute_name|
        object = object.send(attribute_name)
      end if parts.any?

      if object.respond_to?(:"human_#{attribute_name}")
        object.send :"human_#{attribute_name}"
      else
        object.send(attribute_name)
      end
    rescue
      options.key?(:if_raise) ? options[:if_raise] : raise
    end

    def attribute_label attribute_name
      model_class = html_options[:model] || @object.class
      model_class.human_attribute_name(attribute_name)
    end

  end
end
