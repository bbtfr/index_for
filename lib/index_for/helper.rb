module IndexFor
  module Helper
    include IndexFor::ShareHelper

    # Creates a table around the objects and yields a builder.
    #
    # Example:
    #
    #   index_for @users do |t|
    #     t.attribute :name
    #     t.attribute :email
    #   end
    #
    def index_for objects, html_options = {}, &block
      html_options = html_options.dup

      tag = html_options[:table_tag] || IndexFor.table_tag

      klass = html_options[:klass] || objects.try(:klass) || objects.first.class

      html_options[:id] ||= index_for_id(klass)
      html_options[:class] = index_for_class(klass, html_options)

      head = index_for_head(klass.new, html_options, &block)
      body = index_for_body(objects, html_options, &block)
      content = head + body

      content_tag(tag, content, html_options)
    end

    # Create action links and yields a builder.
    #
    # Example:
    #
    #   index_for_actions @user do |a|
    #     a.action_link :show
    #     a.action_link :edit
    #   end
    #
    #   index_for_actions @user, :show, :edit
    #
    def index_for_actions object, *action_names, &block
      html_options = action_names.extract_options!
      action_names = [:show, :edit, :destroy] if action_names == [:all]

      builder = IndexFor::ActionBuilder.new(object, html_options, self)
      
      content = capture(builder) do |a|
        action_names.map do |action_name|
          a.action_link action_name
        end.join.html_safe
      end

      content += capture(builder, &block) if block

      content
    end

    # Creates a desc list around the object and yields a builder.
    #
    # Example:
    #
    #   show_for @user do |l|
    #     l.attribute :name
    #     l.attribute :email
    #   end
    #
    def show_for object, html_options = {}, &block
      html_options = html_options.dup

      tag = html_options[:desc_list_tag] || IndexFor.desc_list_tag

      html_options[:id] ||= show_for_id(object)
      html_options[:class] = show_for_class(object, html_options)

      content = capture(IndexFor::DescListColumnBuilder.new(object, html_options, self), &block)

      content_tag(tag, content, html_options)
    end

    private

    def index_for_head object, html_options = {}, &block
      head_tag = html_options[:head_tag] || IndexFor.table_head_tag
      row_tag = html_options[:row_tag] || IndexFor.table_row_tag

      head_html_options = html_options[:head_html] || {}
      append_class head_html_options, IndexFor.table_head_class

      row_html_options = html_options[:row_html] || {}
      append_class row_html_options, IndexFor.table_row_class

      content = capture(IndexFor::HeadColumnBuilder.new(object, html_options, self), &block)

      content_tag(head_tag, head_html_options) do
        content_tag(row_tag, content, row_html_options)
      end
    end

    def index_for_body objects, html_options = {}, &block
      body_tag = html_options[:body_tag] || IndexFor.table_body_tag
      row_tag = html_options[:row_tag] || IndexFor.table_row_tag

      body_html_options = html_options[:body_html] || {}
      append_class body_html_options, IndexFor.table_body_class

      row_html_options = html_options[:row_html] || {}
      append_class row_html_options, IndexFor.table_row_class

      content_tag(body_tag, body_html_options) do
        objects.map do |object|
          content = capture(IndexFor::BodyColumnBuilder.new(object, html_options, self), &block)
          content_tag(row_tag, content, row_html_options)
        end.join.html_safe
      end
    end

    # Finds the class representing the collection
    # IndexFor
    def index_for_id klass
      klass.model_name.plural
    end

    def index_for_class klass, html_options
      append_class html_options, "table", klass.model_name.plural, IndexFor.table_class
    end

    # ShowFor
    def show_for_id object
      dom_id object
    end

    def show_for_class object, html_options
      append_class html_options, "table", dom_class(object), IndexFor.table_class
    end
  end
end

ActionView::Base.send :include, IndexFor::Helper