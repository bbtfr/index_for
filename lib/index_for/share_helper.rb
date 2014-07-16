module IndexFor
  module ShareHelper
    private

    def append_class html_options, *classes
      classes << html_options[:class]
      classes.compact!
      html_options[:class] = classes.join(" ") if classes.any?
    end

    def append_html_class options, *classes
      options[:html] ||= {}
      append_class options[:html], *classes
    end

    def translate i18n_key, options = {}
      I18n.t(i18n_key, options.reverse_merge(scope: :index_for))
    end
  end
end