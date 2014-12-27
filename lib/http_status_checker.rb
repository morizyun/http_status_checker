require 'net/http'
require 'parallel'

require 'http_status_checker/version'

require 'http_status_checker/error'
require 'http_status_checker/connection'
require 'http_status_checker/base'

module HttpStatusChecker
  extend HttpStatusChecker::Base
end
