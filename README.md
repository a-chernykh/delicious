[![Gem Version](https://badge.fury.io/rb/delicious.svg)](http://badge.fury.io/rb/delicious) [![Build Status](https://travis-ci.org/andreychernih/delicious.svg?branch=master)](https://travis-ci.org/andreychernih/delicious) [![Coverage Status](https://coveralls.io/repos/andreychernih/delicious/badge.png)](https://coveralls.io/r/andreychernih/delicious)

# Delicious API wrapper

API documentation located [here](https://github.com/SciDevs/delicious-api/tree/master/api).

## Requirements

Ruby versions higher than or equal to `1.9.3` are supported.

## Installation

Add the following line into your Gemfile:

```ruby
gem 'delicious', '~> 1.0.0'
```

## Client configuration

You should [obtain access token](https://github.com/SciDevs/delicious-api/blob/master/api/oauth.md) first.

```ruby
client = Delicious::Client.new do |config|
  config.access_token = 'my-access-token'
end
```

## Bookmarks

### Get bookmarks

`client.bookmarks.all` returns all bookmarks created by user associated with access token. You can paginate results:

```ruby
client.bookmarks.all.offset(50).limit(100)
```

It's possible to filter by tag, starting and ending dates:

```ruby
client.bookmarks.all.tag('angular').from('2013/11/12 10:23:00').to('2013/11/13 12:10:00')
```

### Create

```ruby
client.bookmarks.create url:         'http://example.com',
                        description: 'Example bookmark',
                        tags:        'tag1,tag2,tag3'
```

It returns an instance of `Delicious::Post` which responds to `persisted?`.

### Delete

If you have an instance of `Delicious::Post` which was saved, you can call `delete` on it:

```ruby
post = client.bookmarks.create url: 'http://example.com', description: 'Example bookmark'
post.delete if post.persisted? # => true if bookmark was deleted, false otherwise
```

You can also delete bookmark with a client:

```ruby
client.bookmarks.delete url: 'http://example.com' # => true if bookmark was deleted, false otherwise
```

## Bundles

Bundles are named list of tags. See the following example for how to create a new bundle:

### Create

```ruby
bundle = client.bundles.set 'bundlename', %w(tag1 tag2)
```

It returns an instance of `Delicious::Bundle` on success and throws `Delicious::Error` if something went wrong on the server.

### Delete

You can call `bundle.delete` or `client.bundles.delete('bundlename')` to delete existing bundle. It returns `true` on successful deletion and `false` otherwise.

### Find by bundle name

```ruby
bundle = client.bundles.find 'bundlename'
```

### All bundles

```ruby
bundles = client.bundles.all
```

## Tags

### Get all tags

```ruby
tags = client.tags.all
```

### Delete tag

```ruby
client.tags.delete 'tag'
```

### Rename tag

```ruby
client.tags.rename 'old_name', 'new_name'
```
