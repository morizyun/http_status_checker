require 'spec_helper'

describe HttpStatusChecker::Connection do
  describe '.get_header' do
    let!(:valid_url) { 'http://www.yahoo.co.jp/' }
    let!(:redirect_url) { 'http://yahoo.co.jp/' }
    let!(:atnd_http_url) { 'http://atnd.org/events/14386' }
    let!(:atnd_https_url) { 'https://atnd.org/events/14386' }

    context 'when get http valid url' do
      it 'return Net::HTTPOK response' do
        response = HttpStatusChecker::Connection.get_header(valid_url)
        expect(response.is_a?(Net::HTTPOK)).to be == true
        expect(response['location']).to be_nil
      end
    end

    context 'when get http redirect url' do
      it 'return Net::HTTPRedirection response' do
        response = HttpStatusChecker::Connection.get_header(redirect_url)
        expect(response.is_a?(Net::HTTPRedirection)).to be == true
        expect(response['location']).to eq(valid_url)
      end
    end

    context 'when get invalid http status(atnd.org)' do
      it 'return Net::HTTPRedirection response' do
        response = HttpStatusChecker::Connection.get_header(atnd_https_url)
        expect(response.is_a?(Net::HTTPRedirection)).to be == true
        expect(response['location']).to eq(atnd_https_url)
      end
    end

    context 'when get http invalid url' do
      let!(:invalid_url) { 'http://www.nothing-dummy.com/' }
      it 'raise SocketError' do
        expect{ HttpStatusChecker::Connection.get_header(invalid_url) }.to raise_error(SocketError)
      end
    end
  end
end