if ENV['CI']
  require 'coveralls'
  Coveralls.wear!
  require 'codeclimate-test-reporter'
  SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter[
      Coveralls::SimpleCov::Formatter,
      CodeClimate::TestReporter::Formatter
  ]
  SimpleCov.start 'test_frameworks'
  CodeClimate::TestReporter.start
end

$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'http_status_checker'
require 'rspec'
require 'vcr'
require 'benchmark'

RSpec.configure do |config|
  config.order = 'random'
end

VCR.configure do |c|
  c.cassette_library_dir = 'spec/vcr'
  c.hook_into :webmock
  c.allow_http_connections_when_no_cassette = true
end