require 'action_view'
require 'index_for/share_helper'
require 'index_for/helper'

module IndexFor
  autoload :Builder, 'index_for/builder'
  autoload :ActionBuilder, 'index_for/builders/action_builder'
  autoload :HeadColumnBuilder, 'index_for/builders/head_column_builder'
  autoload :BodyColumnBuilder, 'index_for/builders/body_column_builder'
  autoload :DescListColumnBuilder, 'index_for/builders/desc_list_column_builder'

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
  mattr_accessor :desc_list_tag
  @@desc_list_tag = :dl
  mattr_accessor :desc_list_class
  @@desc_list_class = nil

  mattr_accessor :desc_list_label_tag
  @@desc_list_label_tag = :dt
  mattr_accessor :desc_list_label_class
  @@desc_list_label_class = nil

  mattr_accessor :desc_list_content_tag
  @@desc_list_content_tag = :dd
  mattr_accessor :desc_list_content_class
  @@desc_list_content_class = nil

  mattr_accessor :blank_content_class
  @@blank_content_class = "blank"

  mattr_accessor :i18n_format
  @@i18n_format = :default

  mattr_accessor :association_methods
  @@association_methods = [ :name, :title, :to_s ]

  mattr_accessor :label_proc
  @@label_proc = nil

  # Yield self for configuration block:
  #
  #   IndexFor.setup do |config|
  #     config.index_for_tag = :div
  #   end
  #
  def self.setup
    yield self
  end
end
