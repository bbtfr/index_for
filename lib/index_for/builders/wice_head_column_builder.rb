require 'index_for/builder'
require 'index_for/builders/head_column_builder'

module IndexFor
  class WiceHeadColumnBuilder < HeadColumnBuilder

    def attribute attribute_name, options = {}
      model_class = options[:model] || html_options[:model] || @object.class
      order = "#{model_class.table_name}.#{attribute_name}"

      params = @template.params
      direction = params[:direction] || "asc"
      reverse_direction = if order != params[:order] || params[:direction] && params[:direction] == "desc"
          "asc"
        else
          "desc"
        end

      sorting = params[:sortable] != false && options[:sortable] != false

      sorting_class = if order == params[:order]
          "sorting #{direction}"
        elsif sorting
          "sorting"
        end

      sorting_url = if sorting
          @template.url_for(params.merge(order: order, direction: reverse_direction))
        end

      append_html_class options, attribute_class_name(attribute_name), sorting_class

      params = template.params.permit!

      options[:html] ||= {}
      options[:html][:data] ||= {}
      options[:html][:data][:href] = sorting_url

      wrap_with :table_head_cell, attribute_label(attribute_name, options), options
    end

  end
end
