require 'action_view'
require 'index_for/share_helper'
require 'index_for/helper'

module IndexFor
  autoload :Builder, 'index_for/builder'
  autoload :ActionBuilder, 'index_for/builders/action_builder'
  autoload :HeadColumnBuilder, 'index_for/builders/head_column_builder'
  autoload :BodyColumnBuilder, 'index_for/builders/body_column_builder'
  autoload :ListColumnBuilder, 'index_for/builders/list_column_builder'
  autoload :WiceBuilder, 'index_for/builders/wice_builder'
  autoload :WiceHeadColumnBuilder, 'index_for/builders/wice_head_column_builder'

  # IndexFor
  mattr_accessor :table_tag
  @@table_tag = :table
  mattr_accessor :table_class
  @@table_class = nil

  mattr_accessor :table_head_tag
  @@table_head_tag = :thead
  mattr_accessor :table_head_class
  @@table_head_class = nil

  mattr_accessor :table_body_tag
  @@table_body_tag = :tbody
  mattr_accessor :table_body_class
  @@table_body_class = nil

  mattr_accessor :table_row_tag
  @@table_row_tag = :tr
  mattr_accessor :table_row_class
  @@table_row_class = nil

  mattr_accessor :table_head_cell_tag
  @@table_head_cell_tag = :th
  mattr_accessor :table_head_cell_class
  @@table_head_cell_class = nil

  mattr_accessor :table_body_cell_tag
  @@table_body_cell_tag = :td
  mattr_accessor :table_body_cell_class
  @@table_body_cell_class = nil

  mattr_accessor :table_actions_cell_class
  @@table_actions_cell_class = :actions

  mattr_accessor :action_link_class
  @@action_link_class = :action

  # ShowFor
  mattr_accessor :list_tag
  @@list_tag = :dl
  mattr_accessor :list_class
  @@list_class = nil

  mattr_accessor :list_row_tag
  @@list_row_tag = nil
  mattr_accessor :list_row_class
  @@list_row_class = nil

  mattr_accessor :list_label_tag
  @@list_label_tag = :dt
  mattr_accessor :list_label_class
  @@list_label_class = nil

  mattr_accessor :list_content_tag
  @@list_content_tag = :dd
  mattr_accessor :list_content_class
  @@list_content_class = nil

  mattr_accessor :list_label_proc
  @@list_label_proc = nil

  mattr_accessor :blank_content_class
  @@blank_content_class = "blank"

  mattr_accessor :i18n_format
  @@i18n_format = :default

  mattr_accessor :association_methods
  @@association_methods = [ :name, :title, :to_s ]

  mattr_accessor :collection_tag
  @@collection_tag = :ul
  mattr_accessor :collection_column_tag
  @@collection_column_tag = :li

  # Wice IndexFor
  mattr_accessor :per_pages
  @@per_pages = [10, 25, 50, 100]
  mattr_accessor :per_page
  @@per_page = @@per_pages.first

  # Yield self for configuration block:
  #
  #   IndexFor.setup do |config|
  #     config.index_for_tag = :div
  #   end
  #
  def self.setup
    yield self
  end

  mattr_accessor :formatters
  @@formatters = {}
  def self.format key, &block
    formatters[key] = block
  end
end
