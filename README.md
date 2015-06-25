# Exist.IO API Ruby Client

[![Gem Version](https://badge.fury.io/rb/exist.png)](http://badge.fury.io/rb/exist) [![Build Status](https://travis-ci.org/blackxored/exist.png)](https://travis-ci.org/blackxored/exist) [![Coverage Status](https://coveralls.io/repos/blackxored/exist/badge.png?branch=master)](https://coveralls.io/r/blackxored/exist) [![Dependency Status](https://gemnasium.com/blackxored/exist.png)](https://gemnasium.com/blackxored/exist) [![Code Climate](https://codeclimate.com/github/blackxored/exist.png)](https://codeclimate.com/github/blackxored/exist)

## Disclaimer

Please notice that the Exist.IO API is experimental as noticed by their
developers, so it's this library by extension, I'm not affiliated with the Exist
development team, I'm just another user of the platform addicted to the
quantified-self concept ;)

## Installation

Add this line to your application's Gemfile:

    gem 'exist'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install exist

## Usage

### Authentication

All (if not most) requests require authentication. Exist uses a non-expiring
token that you can configure this client with. It also supports username
and password login, although I'd recommend not to store this and use
the token instead.

You can login with username & password:

```ruby

exist = Exist::API.new(username: 'youruser', password: 'yourpass')
```

Then retrieve the token:

```ruby
exist.api_key
```

You can store it somewhere safe, it will try to read from the `EXIST_API_TOKEN`
environment variable if you initialize the client without options. You can also
pass it directly, as you would have expected:

```ruby
Exist::API.new(token: "<YOUR_TOKEN>")
```

### Data methods

From then on, you have access to all of the current endpoints (more
information in the [developer's site](http://developer.exist.io/)),
through the client instance:

* The current user (`#me`).
* Overviews (i.e. Today view) (`#overview`).
* Attributes (`#attributes`, `#attribute`).
* Insights (`#insights`, `#insights_for_attribute`).
* Averages (`#averages`, `#averages_for_attribute`).
* Correlations (`#correlations`).

Notice that most endpoints can only be used with the current user,
hence they don't ask for username, I will update this in the future 
if this changes.

## Roadmap

I intent to make this gem more AR-friendly, with finders, queries, deep search,
to fill the gaps from the API itself.

## Contributing

1. Fork it ( https://github.com/blackxored/exist/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
