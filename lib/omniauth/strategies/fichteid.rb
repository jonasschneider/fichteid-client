require 'omniauth'
require "openid"
require "openid/store/memory"

$openid_store = OpenID::Store::Memory.new

module OmniAuth
  module Strategies
    class FichteID
      include OmniAuth::Strategy
      
      option :site, "http://fichteid.heroku.com/"
      option :key, 'mypw'
      
      def client
        Fichteid::Client.new options[:key], session
      end
      
      def request_phase
        realm = "#{env['rack.url_scheme']}://#{request.host_with_port}"
        
        redirect client.redirect_url :return_to => callback_url, :realm => realm
      end
      
      def callback_phase
        begin
          @info = client.complete(request.params, request.url)
          super
        rescue Fichteid::Client::AuthenticationFailed => e
          fail! e.message
        end
      end
        
      info do
        @info
      end
    end
  end
end

OmniAuth.config.add_camelization 'fichteid', 'FichteID'
OmniAuth.config.add_camelization 'fichte_id', 'FichteID'