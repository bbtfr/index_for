require 'index_for/builder'

module IndexFor
  class DescListColumnBuilder < Builder

    def attribute attribute_name, options = {}, &block
      label_options = options
      label_options[:html] = options[:label_html]
      label = wrap_with :desc_list_label, attribute_label(attribute_name), 
        label_options

      content_options = options
      content_options[:html] = options[:content_html]
      content = wrap_content_with :desc_list_content, attribute_value(attribute_name, 
        options, &block), content_options

      label + content
    end

  end
end