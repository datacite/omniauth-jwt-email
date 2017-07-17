require 'spec_helper'

describe OmniAuth::Strategies::JwtOtp do
  let(:request) { double('Request', :params => {}, :cookies => {}, :env => {}) }
  let(:app) {
    lambda do
      [200, {}, ["Hello."]]
    end
  }

  subject do
    OmniAuth::Strategies::JwtOtp.new(app, 'client_id', 'client_secret', @options || {}).tap do |strategy|
      allow(strategy).to receive(:request) {
        request
      }
    end
  end

  before do
    OmniAuth.config.test_mode = true
  end

  after do
    OmniAuth.config.test_mode = false
  end

  context 'client options' do
    it 'should have correct name' do
      expect(subject.options.name).to eq('jwt-otp')
    end

    describe "default" do
      it 'should have correct site' do
        expect(subject.options.client_options.site).to eq('https://pub.orcid.org')
      end

      it 'should have correct scope' do
        expect(subject.authorize_params['scope']).to eq('/authenticate')
      end

      it 'should have correct token url' do
        expect(subject.options.client_options.token_url).to eq("https://orcid.org/oauth/token")
      end

      it 'should have correct authorize url' do
        expect(subject.options.client_options.authorize_url).to eq('https://orcid.org/oauth/authorize')
      end

      it 'should have correct base url' do
        expect(subject.options.client_options.api_base_url).to eq('https://pub.orcid.org/v2.0')
      end
    end

    describe "redirect_uri" do
      it 'should default to nil' do
        @options = {}
        expect(subject.authorize_params['redirect_uri']).to be_nil
      end

      it 'should set the redirect_uri parameter if present' do
        @options = { redirect_uri: 'https://example.com' }
        expect(subject.authorize_params['redirect_uri']).to eq('https://example.com')
      end
    end
  end

  context 'info' do
    it 'should return name' do
      expect(subject.info[:name]).to eq('Martin Fenner')
    end

    it 'should return email' do
      expect(subject.info[:email]).to eq( "martin.fenner@datacite.org")
    end
  end
end
