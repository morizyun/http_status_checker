require 'spec_helper'

describe HttpStatusChecker::Connection do
  describe '.get_header' do
    let!(:valid_url) { 'http://www.yahoo.co.jp/' }
    let!(:redirect_url) { 'http://yahoo.co.jp/' }

    context 'when get http valid url' do
      it 'return Net::HTTPOK response' do
        response = HttpStatusChecker.get_header(valid_url)
        expect(response.is_a?(Net::HTTPOK)).to be == true
      end
    end

    context 'when get http redirect url' do
      it 'return Net::HTTPRedirection response' do
        response = HttpStatusChecker.get_header(redirect_url)
        expect(response.is_a?(Net::HTTPRedirection)).to be == true
        expect(response['location']).to eq(valid_url)
      end
    end

    context 'when get http invalid url' do
      let!(:invalid_url) { 'http://www.nothing-dummy.com/' }
      it 'raise SocketError' do
        expect{ HttpStatusChecker.get_header(invalid_url) }.to raise_error(SocketError)
      end
    end
  end
end