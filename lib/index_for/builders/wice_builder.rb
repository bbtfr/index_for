require 'index_for/builder'

module IndexFor
  class WiceBuilder < Builder
    attr_accessor :per_page, :page, :order, :direction, :search

    def sortable_fields
      @sortable_fields ||= []
    end

    def searchable_fields
      @searchable_fields ||= []
    end

    def attribute attribute_name, options = {}
      model_class = options[:model] || html_options[:model] || @object
      sortable_fields << (options[:sortable] || "#{model_class.table_name}.#{attribute_name}")
      searchable_fields << "#{model_class.table_name}.#{attribute_name}" if options[:searchable]
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
      self.order = params[:order] if sortable_fields.include? params[:order]
      self.direction = params[:direction] || "asc"
      self.search = params[:search]

      collection = @object
      collection = collection.page(page).per(per_page)
      collection = collection.order("#{order} #{direction.upcase}") if order
      collection = collection.where(searchable_fields.map{|f|"#{f} LIKE '%#{search}%'"}.join(" OR ")) if search
      collection
    end

    def per_pages
      IndexFor.per_pages.each do |per_page|
        yield per_page, @template.url_for(template.params.merge(page: nil, per_page: per_page)), per_page == self.per_page
      end
    end

  end
end
