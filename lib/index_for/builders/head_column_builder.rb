require 'index_for/builder'

module IndexFor
  class HeadColumnBuilder < Builder

    def attribute attribute_name, options = {}
      append_html_class options, attribute_class_name(attribute_name)
      wrap_with :table_head_cell, attribute_label(attribute_name, options), options
    end

    def actions *action_names
      options = action_names.extract_options!
      options[:html] = apply_html_options :table_actions_cell, options

      wrap_with :table_head_cell, translate(:"actions.actions"), options
    end

  end
end
