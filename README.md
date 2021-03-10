# mackerel-client [![CI](https://github.com/mackerelio/mackerel-client-ruby/actions/workflows/ci.yml/badge.svg)](https://github.com/mackerelio/mackerel-client-ruby/actions/workflows/ci.yml) [![Gem Version](https://badge.fury.io/rb/mackerel-client.svg)](https://badge.fury.io/rb/mackerel-client)

mackerel-client is a ruby library to access Mackerel (https://mackerel.io/).

## Usage

```ruby
require 'mackerel/client'

@mackerel = Mackerel::Client.new(:mackerel_api_key => "<Put your API key>")
host = @mackerel.get_host("<hostId>")
```

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'mackerel-client'
```

And then execute:

```sh
bundle
```

Or install it yourself as:

```sh
gem install mackerel-client
```
