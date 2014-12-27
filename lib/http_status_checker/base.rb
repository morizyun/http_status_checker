module HttpStatusChecker
  module Base
    THREAD_LIMIT = 5.freeze
    REDIRECT_MAX = 5.freeze
    RETRY_MAX = 2.freeze

    def check(urls, wait_sec = 1)
      results = []

      host_hash = to_host_hash(urls)
      Parallel.each(host_hash, in_threads: host_hash.keys.count) do |_, urls|
        urls.map.with_index(1) do |url, idx|
          results << get_response(url, wait_sec)
          sleep(wait_sec) if urls.count != idx
        end
      end

      return results
    end

    private

    def get_response(url, wait_sec, redirect_url = nil, redirect_count = 0, retry_count = 0)
      result = HttpStatusChecker::Connection.get_header(redirect_url || url)
      parse_response(redirect_count, redirect_url, result, url, wait_sec)
    rescue => e
      if retry_count < RETRY_MAX
        sleep (wait_sec)
        get_response(url, wait_sec, nil, redirect_count + 1, retry_count + 1)
      end
      { url => { code: result ? result.code : nil, is_alive: false, error: e.message } }
    end

    def parse_response(redirect_count, redirect_url, result, url, wait_sec)
      location_url = result['location']
      if !location_url.nil? && (redirect_url || url) != location_url
        raise InvalidRedirectError if redirect_count > REDIRECT_MAX
        get_response(url, wait_sec, location_url, redirect_count + 1, 0)
      elsif result.code =~ /^(2|3)[0-9]{2}$/
        { url => { code: result.code, is_alive: true, redirect_url: redirect_url } }
      else
        raise InvalidResponseError, "Unknown class #{result.class} : #{result.to_s}"
      end
    end

    def to_host_hash(urls)
      urls = to_array(urls)
      raise ArgumentError, "#{urls} is not String and Array" unless urls.is_a?(Array)

      host_hash = {}
      urls.each do |url|
        host = URI.parse(url).host.to_sym
        host_hash[host] = host_hash[host].nil? ? [url] : host_hash[host] << url
      end
      return host_hash
    end

    def to_array(item)
      case item.class.to_s
        when 'Array'
          item
        when 'String'
          [item]
        else
          nil
      end
    end
  end
end
