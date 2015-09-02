require 'index_for/attribute'

module IndexFor
  class Builder
    include IndexFor::ShareHelper
    include IndexFor::Attribute

    attr_accessor :object, :html_options, :template

    def initialize object, html_options, template
      @object, @html_options, @template = object, html_options, template
    end

    def attribute attribute_name, options = {}, &block; end
    def association attribute_name, options = {}, &block
      attribute attribute_name, options, &block
    end

    def attributes *attribute_names
      options = attribute_names.extract_options!

      attribute_names.map do |attribute_name|
        attribute attribute_name, options
      end.join.html_safe
    end

    def actions *action_names, &block; end

    private

    def apply_html type, options = {} #:nodoc:
      type_tag = html_options[:"#{type}_tag"] || IndexFor.try(:"#{type}_tag")
      type_html_options = apply_html_options type, options

      return type_tag, type_html_options
    end

    def apply_html_options type, options = {}
      type_class = IndexFor.send :"#{type}_class"

      type_html_options = {}
      type_html_options.merge!(html_options[:"#{type}_html"]) if html_options[:"#{type}_html"]
      type_html_options.merge!(options[:html]) if options[:html]

      append_class type_html_options, type_class

      type_html_options
    end


    def wrap_content_with type, content, options = {}, &block #:nodoc:
      type_tag, type_html_options = apply_html type, options
      append_class type_html_options, IndexFor.blank_content_class if content.blank?

      @template.content_tag type_tag, type_html_options do
        format_content(content, options, &block)
      end
    end

    def format_content content, options = {}, &block
      # We need to convert content to_a because when dealing with ActiveRecord
      # Array proxies, the follow statement Array# === content return false
      if block && block.arity == 1
        content = block
      elsif content.respond_to?(:to_ary)
        content = content.to_a
      end

      case content
      when Date, Time, DateTime
        I18n.l content, :format => options[:format] || IndexFor.i18n_format
      when TrueClass
        translate :"index_for.yes", :default => "Yes"
      when FalseClass
        translate :"index_for.no", :default => "No"
      when Array, Hash
        content.empty? ? blank_content(options) :
          collection_content(content, options, &block)
      when Proc
        @template.capture(@object, &content)
      when NilClass
        blank_content(options)
      else
        content.to_s
      end
    end

    def blank_content options
      options[:if_blank] || translate(:blank, :default => "Not specified")
    end

    def collection_content collection, options, &block
      collection_tag = options[:collection_tag] || IndexFor.collection_tag
      collection_column_tag = options[:collection_column_tag] || IndexFor.collection_column_tag
      @template.content_tag collection_tag do
        collection.map do |content|
          if block
            @template.capture content, collection, @object, &block
          else
            @template.content_tag collection_column_tag, content
          end
        end.join.html_safe
      end
    end

    # Gets the default tag set in IndexFor module and apply (if defined)
    # around the given content. It also check for html_options in @options
    # hash related to the current type.
    def wrap_with type, content, options = {} #:nodoc:
      type_tag, type_html_options = apply_html type, options
      if type_tag
        @template.content_tag type_tag, content, type_html_options
      else
        content
      end
    end
  end
end
