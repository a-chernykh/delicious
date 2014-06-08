# Delicious API wrapper

## Client configuration

You should [obtain access token](https://github.com/SciDevs/delicious-api/blob/master/api/oauth.md) first.

```ruby
client = Delicious::Client.new do |config|
  config.access_token = 'my-access-token'
end
```

## Create bookmark

```ruby
client.post url:         'http://example.com',
            description: 'Example bookmark',
            tags:        'tag1,tag2,tag3'
```

It returns an instance of `Delicious::Post` which responds to `persisted?`.
