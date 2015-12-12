require 'index_for/builder'

module IndexFor
  class ListColumnBuilder < Builder

    def attribute attribute_name, options = {}, &block
      label_options = options
      label_options[:html] = options[:label_html]
      label = list_label attribute_name, label_options

      content_options = options
      content_options[:html] = options[:content_html]
      content = list_content attribute_name, content_options, &block

      row_options = options
      row_options[:html] = options[:row_html]
      wrap_with :list_row, label + content, row_options
    end

    def list_label attribute_name, options
      append_html_class options, attribute_class_name(attribute_name)
      wrap_with :list_label, attribute_label(attribute_name, options), options
    end

    def list_content attribute_name, options, &block
      append_html_class options, attribute_class_name(attribute_name)
      wrap_attribute_with :list_content, attribute_name, options, &block
    end

  end
end
