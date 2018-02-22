# mackerel-client [![Build Status](https://travis-ci.org/mackerelio/mackerel-client-ruby.svg?branch=master)](https://travis-ci.org/mackerelio/mackerel-client-ruby) [![Gem Version](https://badge.fury.io/rb/mackerel-client.png)](http://badge.fury.io/rb/mackerel-client)

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
