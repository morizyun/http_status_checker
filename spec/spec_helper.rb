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
require 'fakeweb'

def fixture(path)
  File.read("#{File.dirname(__FILE__)}/fixtures/#{path}")
end

def stub_get(path, fixture_path, options={})
  opts = {
      :body => fixture(fixture_path),
      :content_type => 'application/json; charset=utf-8'
  }.merge(options)
  FakeWeb.register_uri(:get, "#{path}", opts)
end

RSpec.configure do |config|
  config.order = 'random'
end