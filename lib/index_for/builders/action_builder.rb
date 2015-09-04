require 'index_for/builder'

module IndexFor
  class ActionBuilder < Builder

    def action_link action_name, options = {}, &block
      if block
        @template.capture(@object, &block)
      else
        object = @html_options[:namespace] ? @html_options[:namespace].clone.push(@object) : @object
        action_title = translate(:"actions.#{action_name}",
          default: action_name.to_s.humanize).html_safe
        action_html_options = apply_html_options :action_link, options[:html] || {}
        append_class action_html_options, :"action_#{action_name}"

        case action_name
        when :show
          @template.link_to action_title, @template.polymorphic_path(object),
            action_html_options
        when :destroy
          @template.link_to action_title, @template.polymorphic_path(object),
            { data: { method: :delete, confirm: translate(:"actions.confirmation")
            }}.merge(action_html_options)
        else
          @template.link_to action_title, @template.polymorphic_path(object,
            action: action_name), action_html_options
        end
      end
    end

  end
end
