# HttpStatusChecker

Easily Checking http status by http header with Multi-threaded

## Features

* Get http status by only http header
* A threaded (fast) per host name
* Warnings for links that redirect to valid links

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'http_status_checker'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install http_status_checker

## Usage Command Line

    $ http_status http://morizyun.github.io

## Usage Ruby Program

    require 'http_status_checker'

    HttpStatusChecker.check 'http://morizyun.github.io

## Contributing

1. Fork it ( https://github.com/morizyun/http_status_checker/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request