require 'spec_helper'

describe HttpStatusChecker::Connection do
  let!(:valid_url) { 'http://www.yahoo.co.jp/' }
  let!(:redirect_url) { 'http://yahoo.co.jp/' }
  let!(:morizyun_404) { 'http://morizyun.github.io/404/' }

  describe '.get_header' do
    context 'when get http valid url' do
      it 'returns is_alive = true, redirect = nil, error = nil' do
        response = HttpStatusChecker.check(valid_url)
        expect(response.first[valid_url][:is_alive]).to eq(true)
        expect(response.first[valid_url][:redirect_url]).to be_nil
        expect(response.first[valid_url][:error]).to be_nil
      end
    end

    context 'when get http redirect url' do
      it 'returns is_alive = true, redirect = valid_url, error = nil' do
        response = HttpStatusChecker.check(redirect_url)
        expect(response.first[redirect_url][:is_alive]).to eq(true)
        expect(response.first[redirect_url][:redirect_url]).to eq(valid_url)
        expect(response.first[redirect_url][:error]).to be_nil
      end
    end

    context 'when get http invalid url' do
      let!(:invalid_url) { 'http://www.nothing-dummy.com/' }
      it 'returns is_alive = false, redirect = nil, error present' do
        response = HttpStatusChecker.check(invalid_url)
        expect(response.first[invalid_url][:is_alive]).to eq(false)
        expect(response.first[invalid_url][:redirect_url]).to be_nil
        expect(response.first[invalid_url][:error]).not_to be_nil
      end
    end

    context 'when get 404 error' do
      let!(:invalid_url) { 'http://morizyun.github.io/404/' }
      it 'returns is_alive = false, redirect = nil, error present' do
        response = HttpStatusChecker.check(invalid_url)
        expect(response.first[invalid_url][:is_alive]).to eq(false)
        expect(response.first[invalid_url][:redirect_url]).to be_nil
        expect(response.first[invalid_url][:error]).not_to be_nil
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
end