# HttpStatusChecker 

[![Build Status](https://travis-ci.org/morizyun/http_status_checker.svg)](https://travis-ci.org/morizyun/http_status_checker) [![Code Climate](https://codeclimate.com/github/morizyun/http_status_checker/badges/gpa.svg)](https://codeclimate.com/github/morizyun/http_status_checker) [![Test Coverage](https://codeclimate.com/github/morizyun/http_status_checker/badges/coverage.svg)](https://codeclimate.com/github/morizyun/http_status_checker) [![endorse](https://api.coderwall.com/morizyun/endorsecount.png)](https://coderwall.com/morizyun)

Easily Checking http status with Multi-threaded

## Features

* Get http status
* A threaded (fast) per host name
* Return redirect url and errors when get http access

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'http_status_checker'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install http_status_checker

## Usage on Command Line

    $ http_status_checker -u http://morizyun.github.io
    #=> url: http://morizyun.github.io
    #=> response: {:code=>"200", :is_alive=>true, :redirect_url=>nil}

## Usage on Ruby Program

    require 'http_status_checker'

    urls = ['http://morizyun.github.io', 'http://www.yahoo.co.jp']
    interval_sec = 1
    HttpStatusChecker.check urls, interval_sec
    #=> [{"http://morizyun.github.io"=>{:code=>"200", :is_alive=>true, :redirect_url=>nil}}, 
    #=> {"http://www.yahoo.co.jp"=>{:code=>"200", :is_alive=>true, :redirect_url=>nil}}]

## Contributing

1. Fork it ( https://github.com/morizyun/http_status_checker/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
