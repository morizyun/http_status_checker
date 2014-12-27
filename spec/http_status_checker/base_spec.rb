require 'spec_helper'

describe HttpStatusChecker::Connection do
  let!(:valid_url) { 'http://www.yahoo.co.jp/' }
  let!(:redirect_url) { 'http://yahoo.co.jp/' }

  describe '.check' do
    context 'when set valid url' do
      it 'returns is_alive = true, redirect = nil, error = nil' do
        response = HttpStatusChecker.check(valid_url)
        expect(response.first[valid_url][:is_alive]).to eq(true)
        expect(response.first[valid_url][:redirect_url]).to be_nil
        expect(response.first[valid_url][:error]).to be_nil
      end
    end

    context 'when set valid url with invalid http status' do
      let!(:atnd_http_url)  { 'http://atnd.org/events/14386' }
      let!(:atnd_https_url) { 'https://atnd.org/events/14386' }
      it 'returns is_alive = true, redirect = nil, error = nil' do
        response = HttpStatusChecker.check(atnd_http_url)
        expect(response.first[atnd_http_url][:is_alive]).to eq(true)
        expect(response.first[atnd_http_url][:redirect_url]).to eq(atnd_https_url)
        expect(response.first[atnd_http_url][:error]).to be_nil
      end
    end

    context 'when set 2 urls' do
      let!(:morizyun_css) { 'http://morizyun.github.io/blog/css3-html-front-coding-book-review/' }
      let!(:morizyun_js) { 'http://morizyun.github.io/blog/javascript-learning-tech-yourself_01/' }
      it 'returns is_alive = true, error = nil' do
        response, time = measure_time do
          HttpStatusChecker.check([morizyun_css, morizyun_js])
        end
        expect(parse(response, morizyun_css)[:is_alive]).to eq(true)
        expect(parse(response, morizyun_css)[:error]).to    be_nil
        expect(parse(response, morizyun_js)[:is_alive]).to  eq(true)
        expect(parse(response, morizyun_js)[:error]).to     be_nil
        expect(time).to be >= 1.0
      end
    end

    context 'when set 2 urls & wait_sec = 2' do
      let!(:morizyun_css) { 'http://morizyun.github.io/blog/css3-html-front-coding-book-review/' }
      let!(:morizyun_js) { 'http://morizyun.github.io/blog/javascript-learning-tech-yourself_01/' }
      it 'returns is_alive = true, error = nil' do
        response, time = measure_time do
          HttpStatusChecker.check([morizyun_css, morizyun_js], wait_sec = 2)
        end
        expect(parse(response, morizyun_css)[:is_alive]).to eq(true)
        expect(parse(response, morizyun_css)[:error]).to    be_nil
        expect(parse(response, morizyun_js)[:is_alive]).to  eq(true)
        expect(parse(response, morizyun_js)[:error]).to     be_nil
        expect(time).to be >= 2.0
      end
    end

    context 'when set http redirect url' do
      it 'returns is_alive = true, redirect = valid_url, error = nil' do
        response = HttpStatusChecker.check(redirect_url)
        expect(response.first[redirect_url][:is_alive]).to eq(true)
        expect(response.first[redirect_url][:redirect_url]).to eq(valid_url)
        expect(response.first[redirect_url][:error]).to be_nil
      end
    end

    context 'when set http invalid url' do
      let!(:invalid_url) { 'http://www.nothing-dummy.com/' }
      it 'returns is_alive = false, redirect = nil, error present' do
        response = HttpStatusChecker.check(invalid_url)
        expect(response.first[invalid_url][:is_alive]).to eq(false)
        expect(response.first[invalid_url][:redirect_url]).to be_nil
        expect(response.first[invalid_url][:error]).not_to be_nil
      end
    end

    context 'when set 404 error' do
      let!(:morizyun_404) { 'http://morizyun.github.io/404/' }
      it 'returns is_alive = false, redirect = nil, error present' do
        response = HttpStatusChecker.check(morizyun_404)
        expect(response.first[morizyun_404][:is_alive]).to eq(false)
        expect(response.first[morizyun_404][:redirect_url]).to be_nil
        expect(response.first[morizyun_404][:error]).not_to be_nil
      end
    end
  end

  describe '.to_host_hash' do
    context 'when post 2urls' do
      it 'returns host with urls array in hash' do
        host_hash = HttpStatusChecker.__send__(:to_host_hash, [valid_url, redirect_url])
        expect(host_hash['www.yahoo.co.jp'.to_sym]).to eq([valid_url])
        expect(host_hash['yahoo.co.jp'.to_sym]).to eq([redirect_url])
      end
    end
  end

  def parse(response, search_url)
    response.each do |hash|
      return hash.values.first if hash.keys.first == search_url
    end
  end

  def measure_time(&block)
    start_at = Time.now
    result = block.call
    finish_at = Time.now
    return [result, finish_at - start_at]
  end
end

