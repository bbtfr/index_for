# IndexFor

[![Gem Version](https://fury-badge.herokuapp.com/rb/index_for.png)](http://badge.fury.io/rb/index_for)
[![Build Status](https://api.travis-ci.org/bbtfr/index_for.png?branch=master)](http://travis-ci.org/bbtfr/index_for)
[![Code Climate](https://codeclimate.com/github/bbtfr/index_for.png)](https://codeclimate.com/github/bbtfr/index_for)

Inspired by [plataformatec/show_for](https://github.com/plataformatec/show_for), IndexFor allows you to quickly list models information with I18n features.

```erb
<%= index_for @users do |u| %>
  <%= u.attribute :name %>
  <%= u.attribute :"profile.nickname" %>
  <%= u.attribute :confirmed? %>
  <%= u.attribute :created_at, :format => :short %>
  <%= u.attribute :last_sign_in_at, :if_blank => "User did not access yet",
                  :html => { :id => "sign_in_timestamp" } %>

  <%= u.attribute :photo do |user| %>
    <%= image_tag(user.photo_url) %>
  <% end %>

  <%= u.attribute :tags, :to_sentence => true %>

  <%= u.ations :all %>
<% end %>
```

## Installation

Install the gem by adding it to your Gemfile and bundle it up:

    gem 'index_for', github: 'bbtfr/index_for'

Run the generator:

    rails generate index_for:install

And you are ready to go.

Note: This gem is only supported with Rails 3.2 and 4, so if you want to use it with 
older versions of Rails, check out other similar gems, such as [wice_grid](https://github.com/leikind/wice_grid) or [datagrid](https://github.com/bogdan/datagrid).

## Usage

IndexFor allows you to quickly list models information with I18n features.

```erb
<%= index_for @admins do |a| %>
  <%= a.attribute :name %>
  <%= a.attribute :login, :with => :upcase %>
  <%= a.attribute :username, :value => :human_login %>
  <%= a.attribute :confirmed? %>
  <%= a.attribute :created_at, :format => :short %>
  <%= a.attribute :last_sign_in_at, :if_blank => "Administrator did not access yet"
                  :html => { :id => "sign_in_timestamp" } %>

  <%= a.attribute :photo do |admin| %>
    <%= image_tag(admin.photo_url) %>
  <% end %>

  <%= a.fields_for :photo do |t| %>
    <%= t.attribute :width %>
    <%= t.attribute :height %>
  <% end %>

  <%= a.attribute :tags, :with => :to_sentence %>

  <%= a.attribute :tags, :collection_tag => :ol, :collection_column_tag => :li %>

  <%= a.attribute :tags do |admin| %>
    <%= admin.tags.to_sentence.upcase %>
  <% end %>

  <%= a.attribute :tags do |tag, tags, admin| %>
    <li><%= tag.upcase %></li>
  <% end %>

  <%= a.attribute :raise_error, value: :"method_return_nil.other_method", if_raise: nil %>

  <% a.actions :all %>
<% end %>
```

Will generate something like:

```html
<table class="index_for admins table" id="admins">
  <thead>
    <tr class="admin">
      <th class="attr_name"> Name </th>
      <th class="attr_login"> Login </th>
      <th class="attr_username"> Username </th>
      <th class="attr_confirmed"> Confirmed? </th>
      <th class="attr_created_at"> Created at </th>
      <th id="sign_in_timestamp" class="attr_last_sign_in_at"> 
        Last sign in at 
      </th>
      <th class="attr_photo"> Photo </th>
      <th class="attr_biography"> Biography </th>
      <th class="attr_tags"> Tags </th>
      <th class="attr_tags"> Tags </th>
      <th class="attr_tags"> Tags </th>
      <th class="attr_tags"> Tags </th>
      <th class="attr_tags"> Raise Error </th>
      <th class="actions"> Actions </th>
    </tr>
  </thead>
  <tbody>
    <tr class="admin" id="admin_1">
      <td class="attr_name"> José Valim </td>
      <td class="attr_login"> JVALIM </td>
      <td class="attr_username"> Jvalim </td>
      <td class="attr_confirmed"> Yes </td>
      <td class="attr_created_at"> 13/12/2009 - 19h17 </td>
      <td id="sign_in_timestamp" class="attr_last_sign_in_at">
        Administrator did not access yet
      </td>
      <td class="attr_photo"> <img src="path/to/photo" /> </td>

      <td class="attr_photo_width"> 600 </td>
      <td class="attr_photo_height"> 800 </td>

      <td class="attr_biography">
        Etiam porttitor eros ut diam vestibulum et blandit lectus tempor. Donec
        venenatis fermentum nunc ac dignissim. Pellentesque volutpat eros quis enim
        mollis bibendum. Ut cursus sem ac sem accumsan nec porttitor felis luctus.
        Sed purus nunc, auctor vitae consectetur pharetra, tristique non nisi.
      </td>

      <td class="attr_tags"> eros, sem and accumsan </td>
      
      <td class="attr_tags">
        <ol>
          <li>eros</li>
          <li>sem</li>
          <li>accumsan</li>
        </ol>
      </td>
      
      <td class="attr_tags"> EROS, SEM AND ACCUMSAN </td>
      
      <td class="attr_tags">
        <ul>
          <li>EROS</li>
          <li>SEM</li>
          <li>ACCUMSAN</li>
        </ul>
      </td>

      <td class="attr_raise_error">
        Not specified
      </td>

      <td class="actions">
        <a class="action action_show" href="/admins/1">Show</a>
        <a class="action action_edit" href="/admins/1/edit">Edit</a>
        <a class="action action_destroy" href="/admins/1" data-method="delete" data-confirm="Are you sure?">Delete</a>
      </td>
    </tr>
  </tbody>
</table>
```

You can also show a list of attributes, useful if you don't need to change any configuration:

```erb
<%= index_for @admins do |a| %>
  <%= a.attributes :name, :confirmed?, :created_at %>
<% end %>
```

This gem also implements a helper method `show_for` to quickly show a model information with I18n features, which is yet another implementation of [plataformatec/show_for](https://github.com/plataformatec/show_for) and will generate a description list (dl/dt/dd) by default.

```erb
<%= show_for @admin do |a| %>
  <%= a.attribute :name %>
  <%= a.attribute :login, :with => :upcase %>
  <%= a.attribute :username, :value => :human_login %>
  <%= a.attribute :confirmed? %>
  <%= a.attribute :created_at, :format => :short %>
  <%= a.attribute :last_sign_in_at, :if_blank => "Administrator did not access yet"
                  :html => { :id => "sign_in_timestamp" } %>

  <%= a.attribute :photo do |admin| %>
    <%= image_tag(admin.photo_url) %>
  <% end %>

  <%= a.attribute :tags, :with => :to_sentence %>

  <%= a.label :login %>
  <%= a.content :username %>
<% end %>
```

## Value lookup

IndexFor uses the following sequence to get the attribute value:

* use the output of a block argument if given
* use the output of the `:value` argument if given
* use the output of the `:with` argument if given
* check if a `:"human_#{attribute}"` method is defined
* retrieve the attribute directly.
* attribute name `:"#{method1}.#{method2}"` is allowed, which will use the output of `object.method1.method2`, you can call a method chain in this way.

## Options

IndexFor handles a series of options. Those are:

For `attribute`:

* __:format__ - Sent to I18n.localize when the attribute is a date/time object.

* __:value__ - Can be used instead of block. If a Symbol is called as instance method.

* __:with__ - Can be used to format output. It will effect same as attribute name `:"#{attribute_name}.#{options[:with]}"`.

* __:if_blank__ - An object to be used if the value is blank. Not escaped as well.

* __:if_raise__ - What to display when an error raised, raise an error by default.

* __:collection_tag__, __:collection_column_tag__ - Wrapper with these tags when the attribute is an array or a hash.

* __:label__ - Overwrite the default label.

For `action_link`:

* __:url__ - `link_path` used for `link_to`, `polymorphic_url` by default.

* __:method__ - `rails-ujs` `data-method`.

* __:confirm__ - `rails-ujs` `data-confirm`.

For `index_for`, `fields_for`:

* __:model__ - Model Class, used for generating i18n table header or description list label, `ActiveRecord::Relation#klass` / `Array#first.class` by default.

## Actions

IndexFor also exposes the actions method. In case you want to use the action links:

```erb
<%= index_for @admins do |a| %>
  <%# :all means :show, :edit, :destroy %>
  <%= a.actions :all %>

  <%= a.actions :show, :edit %>
<% end %>
```

Optionally, if you want to customize the inner part of the action link 
(e.g. using your own link), you can do so by using action_link method
that will be called with a routable action for the resource, or a block. E.g.:

```erb
<%= index_for @admins do |a| %>
  <%= a.actions do |act| %>
    <%= act.action_link :show %>

    <%= act.action_link :cancel, data: { method: :delete } %>

    <%= act.action_link :cancel do |admin| %>
      <%= link_to "Cancel", cancel_admin_path(admin), data: { method: :delete } %>
    <% end %>
  <% end %>
<% end %>
```

If you want to use action links without `index_for` table, E.g.: in you show page, you can call this helper method `index_for_actions`

```erb
<%= index_for_actions @admin, :all %>
```

## Maintainers

* bbtfr (http://github.com/bbtfr)

## Bugs and Feedback

If you discover any bugs or want to drop a line, feel free to create an issue on GitHub.

http://github.com/bbtfr/index_for/issues

MIT License.
