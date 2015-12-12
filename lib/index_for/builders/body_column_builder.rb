require 'index_for/builder'

module IndexFor
  class BodyColumnBuilder < Builder

    def attribute attribute_name, options = {}, &block
      append_html_class options, attribute_class_name(attribute_name)
      wrap_attribute_with :table_body_cell, attribute_name, options, &block
    end

    def actions *action_names, &block
      options = action_names.extract_options!
      options[:html] = apply_html_options :table_actions_cell, options
      options[:namespace] = @html_options[:namespace]

      content = @template.index_for_actions @object, *action_names,
        options, &block

      wrap_with :table_body_cell, content, options
    end

  end
end
