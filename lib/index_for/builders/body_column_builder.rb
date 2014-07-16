require 'index_for/builder'

module IndexFor
  class BodyColumnBuilder < Builder

    def attribute attribute_name, options = {}, &block
      wrap_content_with :table_body_cell, attribute_value(attribute_name, 
        options, &block), options
    end

    def actions *action_names, &block
      options = action_names.extract_options!
      options[:html] = apply_html_options :table_actions_cell, options

      content = @template.index_for_actions @object, *action_names, 
        options, &block

      wrap_with :table_body_cell, content, options
    end

  end
end