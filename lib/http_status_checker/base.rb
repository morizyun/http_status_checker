module HttpStatusChecker
  module Base
    THREAD_LIMIT = 5.freeze
    REDIRECT_MAX = 5.freeze
    RETRY_MAX = 1.freeze

    class InvalidResponseError < StandardError; end
    class InvalidRedirectError < StandardError; end

    def check(urls, wait_sec = 1)
      results = []

      host_hash = to_host_hash(urls)
      Parallel.each(host_hash, in_threads: host_hash.keys.count) do |_, urls|
        urls.map.with_index(1) do |url, idx|
          results << get_response(url)
          sleep(wait_sec) if urls.count != idx
        end
      end

      return results
    end

    private

    def get_response(url, redirect_url = nil, redirect_count = 0, retry_count = 0, result = nil)
      result = get_header(redirect_url || url)
      if result.is_a?(Net::HTTPRedirection) # redirect
        redirect_url = result['location']
        raise InvalidRedirectError if redirect_url.nil? || redirect_count > REDIRECT_MAX
        get_response(url, redirect_url, redirect_count + 1, 0)
      elsif result.is_a?(Net::HTTPOK)
        { url => { code: result.code, is_alive: true, redirect_url: redirect_url } }
      else
        raise InvalidResponseError, "Unknown class #{result.class} : #{result.to_s}"
      end
    rescue => e
      if retry_count < RETRY_MAX
        retry_count += 1
        retry
      end
      code = result ? result.code : nil
      { url => { code: code, is_alive: false, error: e.message } }
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
