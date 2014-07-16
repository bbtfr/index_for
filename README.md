# IndexFor

[![Gem Version](https://fury-badge.herokuapp.com/rb/index_for.png)](http://badge.fury.io/rb/index_for)
[![Build Status](https://api.travis-ci.org/bbtfr/index_for.png?branch=master)](http://travis-ci.org/bbtfr/index_for)
[![Code Climate](https://codeclimate.com/github/bbtfr/index_for.png)](https://codeclimate.com/github/bbtfr/index_for)

Inspired by [plataformatec/show_for](https://github.com/plataformatec/show_for), IndexFor allows you to quickly show models information with I18n features.

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

  <%= u.association :company %>
  <%= u.association :tags, :to_sentence => true %>

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

IndexFor allows you to quickly show a model information with I18n features.

```erb
<%= index_for @admins do |a| %>
  <%= a.attribute :name %>
  <%= a.attribute :login, :value => :upcase %>
  <%= a.attribute :confirmed? %>
  <%= a.attribute :created_at, :format => :short %>
  <%= a.attribute :last_sign_in_at, :if_blank => "Administrator did not access yet"
                  :html => { :id => "sign_in_timestamp" } %>

  <%= a.attribute :photo do |admin| %>
    <%= image_tag(admin.photo_url) %>
  <% end %>

  <% a.attribute :biography %>

  <% a.actions :all %>
<% end %>
```

Will generate something like:

```html
<table class="index_for admins table" id="admins">
  <thead>
    <tr class="admin">
      <th class="admin_name"> Name </th>
      <th class="admin_login"> Login </th>
      <th class="admin_confirmed"> Confirmed? </th>
      <th class="admin_created_at"> Created at </th>
      <th id="sign_in_timestamp" class="admin_last_sign_in_at"> 
        Last sign in at 
      </th>
      <th class="admin_photo"> Photo </th>
      <th class="admin_biography"> Biography </th>
      <th class="actions"> Actions </th>
    </tr>
  </thead>
  <tbody>
    <tr class="admin" id="admin_1">
      <td class="admin_name"> José Valim </td>
      <td class="admin_login"> JVALIM </td>
      <td class="admin_confirmed"> Yes </td>
      <td class="admin_created_at"> 13/12/2009 - 19h17 </td>
      <td id="sign_in_timestamp" class="admin_last_sign_in_at">
        Administrator did not access yet
      </td>
      <td class="admin_photo"> <img src="path/to/photo" /> </td>
      <td class="admin_biography">
        Etiam porttitor eros ut diam vestibulum et blandit lectus tempor. Donec
        venenatis fermentum nunc ac dignissim. Pellentesque volutpat eros quis enim
        mollis bibendum. Ut cursus sem ac sem accumsan nec porttitor felis luctus.
        Sed purus nunc, auctor vitae consectetur pharetra, tristique non nisi.
      </td>
      <td class="actions">
        <a href="/admins/1">Show</a>
        <a href="/admins/1/edit">Edit</a>
        <a href="/admins/1" data-method="delete" data-confirm="Are you sure?">Delete</a>
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

## Value lookup

IndexFor uses the following sequence to get the attribute value:

* use the output of a block argument if given
* use the output of the `:value` argument if given
* check if a `:"human_#{attribute}"` method is defined
* retrieve the attribute directly.
* attribute name `:"#{method1}.#{method2}"` is allowed, which will use the output of `object.method1.method2`, you can call a method chain in this way.

## Options

IndexFor handles a series of options. Those are:

* __:format__ - Sent to I18n.localize when the attribute is a date/time object.

* __:value__ - Can be used instead of block. If a Symbol is called as instance method.

* __:if_blank__ - An object to be used if the value is blank. Not escaped as well.

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

## Associations

IndexFor also supports associations.

```erb
<%= index_for @artworks do |a| %>
  <%= a.association :artist %>
  <%= a.association :artist, :using => :name_with_title %>
  <%= a.attribute :"artist.name_with_title" %>

  <%= a.association :tags %>
  <%= a.association :tags, :to_sentence => true %>
  <%= a.association :tags do |artwork| %>
    <%= artwork.tags.map(&:name).to_sentence %>
  <% end %>

  <%= a.association :fans, :collection_tag => :ol do |fan| %>
    <li><%= link_to fan.name, fan %></li>
  <% end %>
<% end %>
```

The first is a `has_one` or `belongs_to` association, which works like an attribute
to IndexFor, except it will retrieve the artist association and try to find a
proper method from `IndexFor.association_methods` to be used. You can pass
the option :using to tell (and not guess) which method from the association
to use.

:tags is a `has_and_belongs_to_many` association which will return a collection.
IndexFor can handle collections by default by wrapping them in list (`<ul>` with
each item wrapped by an `<li>`). However, it also allows you to give `:to_sentence`
or `:join` it you want to render them inline.

You can also pass a block which expects an argument to association. In such cases,
a wrapper for the collection is still created and the block just iterates over the
collection objects.

Here are some other examples of the many possibilites to custom the output content:

```erb
<%= u.association :relationships, :label => 'test' do |user| %>
  <% user.relationships.each do |relation| %>
    <%= relation.related_user.name if relation.related_user_role == 'supervisor' %>
  <% end %>
<% end %>

<%= u.attribute :gender do |user| %>
  <%= content_tag :span, t("helpers.enum_select.user.gender.#{user.gender}") %>
<% end %>
```

## Maintainers

* bbtfr (http://github.com/bbtfr)

## Bugs and Feedback

If you discover any bugs or want to drop a line, feel free to create an issue on GitHub.

http://github.com/bbtfr/index_for/issues

MIT License.
