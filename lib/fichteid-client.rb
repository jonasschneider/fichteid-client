require "fichteid-client/version"

require "openid"
require "openid/store/memory"

require 'openssl'
require 'base64'

$fichteid_openid_store = OpenID::Store::Memory.new

module Fichteid
  class Client
    DEFAULT_ATTRIBUTES = { :site => "http://fichteid.heroku.com/" }
    class AuthenticationFailed < StandardError; end
    
    def initialize key, session, attrs = DEFAULT_ATTRIBUTES
      @key = key
      @consumer ||= OpenID::Consumer.new(session, $fichteid_openid_store)
      @site = attrs[:site]
    end
    
    def redirect_url attrs = {}
      raise 'need a return url' unless attrs[:return_to]
      oidreq = @consumer.begin @site
      
      signature = OpenSSL::HMAC.digest(OpenSSL::Digest::Digest.new('sha1'), @key, attrs[:return_to])
      
      url = oidreq.redirect_url(attrs[:realm], attrs[:return_to], false)
      url << "&return_url_signature=#{Base64.urlsafe_encode64(signature)}"
      
      url
    end
    
    def complete params, url
      result = @consumer.complete params, url

      if result.status == OpenID::Consumer::SUCCESS
        result.get_signed_ns 'http://openid.net/extensions/sreg/1.1'
      else
        raise AuthenticationFailed, result.inspect
      end
    end
  end
end