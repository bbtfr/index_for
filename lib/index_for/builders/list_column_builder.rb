require 'index_for/builder'

module IndexFor
  class ListColumnBuilder < Builder

    def attribute attribute_name, options = {}, &block
      label_options = options
      label_options[:html] = options[:label_html]

      content_options = options
      content_options[:html] = options[:content_html]

      row_options = options
      row_options[:html] = options[:row_html]

      wrap_with :list_row, label(attribute_name, label_options) + 
        content(attribute_name, options, &block), row_options
    end

    def label attribute_name, options
      append_html_class options, :"attr_#{attribute_name}"
      wrap_with :list_label, attribute_label(attribute_name), options
    end

    def content attribute_name, options, &block
      append_html_class options, :"attr_#{attribute_name}"
      wrap_content_with :list_content, attribute_value(attribute_name, 
        options), options, &block
    end

  end
end