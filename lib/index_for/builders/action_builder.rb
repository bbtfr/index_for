require 'index_for/builder'

module IndexFor
  class ActionBuilder < Builder

    def action_link action_name, options = {}, &block
      if block
        @template.capture(@object, &block)
      else
        object = @html_options[:namespace] ? @html_options[:namespace].clone.push(@object) : @object
        action_title = (translate(:"actions.#{action_name}") || action_name.to_s.humanize).html_safe
        action_html_options = apply_html_options :action_link, options
        append_class action_html_options, :"action_#{action_name}", options[:class]
        action_html_options[:data] ||= {}
        action_html_options[:data].reverse_merge!(options.slice(:method, :confirm))

        link_path = options[:url] || case action_name
          when :show, :destroy
            @template.polymorphic_path(object)
          else
            @template.polymorphic_path(object, action: action_name)
          end

        action_html_options[:data].reverse_merge!( method: :delete,
          confirm: translate(:"actions.confirmation")) if action_name == :destroy

        @template.link_to action_title, link_path, action_html_options
      end
    end

  end
end
