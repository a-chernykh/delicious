# Delicious API wrapper

API documentation located [here](https://github.com/SciDevs/delicious-api/tree/master/api).

## Installation

Add the following line into your Gemfile:

```ruby
gem 'delicious', github: 'andreychernih/delicious'
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

`client.all` returns all bookmarks created by user associated with access token. You can paginate results:

```ruby
client.all.offset(50).limit(100)
```

It's possible to filter by tag, starting and ending dates:

```ruby
client.all.tag('angular').from('2013/11/12 10:23:00').to('2013/11/13 12:10:00')
```

### Create

```ruby
client.post url:         'http://example.com',
            description: 'Example bookmark',
            tags:        'tag1,tag2,tag3'
```

It returns an instance of `Delicious::Post` which responds to `persisted?`.

### Delete

If you have an instance of `Delicious::Post` which was saved, you can call `delete` on it:

```ruby
post = client.post url: 'http://example.com', description: 'Example bookmark'
post.delete if post.persisted? # => true if bookmark was deleted, false otherwise
```

You can also delete bookmark with a client:

```ruby
client.delete url: 'http://example.com' # => true if bookmark was deleted, false otherwise
```
