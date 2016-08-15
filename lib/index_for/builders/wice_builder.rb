require 'index_for/builder'

module IndexFor
  class WiceBuilder < Builder
    attr_accessor :per_page, :page, :order, :direction, :search

    def sortable_fields
      @sortable_fields ||= {}
    end

    def searchable_fields
      @searchable_fields ||= []
    end

    def filterable_fields
      @filterable_fields ||= {}
    end

    def parse_option option, default
      option === true ? default : option if option
    end

    def column_exists? field_name
      ActiveRecord::Base.connection.column_exists? *field_name.split(".", 2)
    end

    def attribute attribute_name, options = {}
      model_class = options[:model] || html_options[:model] || @object
      field_name = "#{model_class.table_name}.#{attribute_name}"
      sortable_field = parse_option(options[:sortable] || true, field_name)
      sortable_fields.merge!(field_name => sortable_field) if sortable_field
      searchable_field = parse_option(options[:searchable] || false, field_name)
      searchable_fields << searchable_field if searchable_field
      filterable_field = parse_option(options[:filterable] || false, field_name)
      filterable_fields.merge! filterable_field if filterable_field
      nil
    end

    def fields_for attribute_name, options = {}, &block
      cached_html_options = @html_options
      @html_options = options
      block.call self
      @html_options = cached_html_options
      nil
    end

    def result
      params = @template.params

      self.per_page = (params[:per_page] || IndexFor.per_page).to_i
      self.page = (params[:page] || 1).to_i
      self.order = sortable_fields[params[:order]] if sortable_fields.key? params[:order]
      self.direction = params[:direction] || "asc"
      self.search = params[:search]

      collection = @object
      collection = collection.page(page).per(per_page)
      collection = collection.order(Array.wrap(order).select{|f|column_exists? f}.map{|f|"#{f} #{direction.upcase}"}.join(", ")) if order
      collection = collection.where((searchable_fields.flatten.map{|f|"#{f} LIKE '%#{search}%'"} + filterable_fields.select{|k,v|v}.map{|k,v|"#{k} = #{v}"}).join(" OR ")) if search

      collection
    end

    def per_pages
      params = template.params.permit!
      IndexFor.per_pages.each do |per_page|
        yield per_page, @template.url_for(params.merge(page: nil, per_page: per_page)), per_page == self.per_page
      end
    end

  end
end
