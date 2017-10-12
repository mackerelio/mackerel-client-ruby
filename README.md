# mackerel-client [![Build Status](https://travis-ci.org/mackerelio/mackerel-client-ruby.svg?branch=master)](https://travis-ci.org/mackerelio/mackerel-client-ruby) [![Gem Version](https://badge.fury.io/rb/mackerel-client.png)](http://badge.fury.io/rb/mackerel-client)

mackerel-client is a ruby library to access Mackerel (https://mackerel.io/). CLI tool `mkr.rb` is also provided.

## Usage

```ruby
@mackerel = Mackerel::Client.new(:mackerel_api_key => "<Put your API key>")
host = @mackerel.get_host("<hostId>")
```

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'mackerel-client', path '/path/to/dir'
```

And then execute:

```sh
bundle
```

## Service

* List Services \[GET /api/v0/services\]
```
mkr.rb service list
```

# CLI

## Host

* Get host(s) information from hostname or service, role.
```
mkr.rb host info [--name foo] [--service service] [--role role]
```

* Set status of a host
```
mkr.rb host status --host-id foo --status working
```

* Retire a host
```
mkr.rb host retire --host-id foo
```

* Get status of a host (not implemented yet)
```
mkr.rb host status --host-id foo
```

Note: CLI command has been renamed to `mkr.rb` from 0.0.7.
Primary CLI `mkr` is implemented in Go (https://github.com/mackerelio/mkr).

## Authentication
```
export MACKEREL_APIKEY=foobar
```
