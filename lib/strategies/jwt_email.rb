require 'jwt'

module OmniAuth
  module Strategies
    class JwtEmail
      class ClaimInvalid < StandardError; end

      include OmniAuth::Strategy

      option :name, "jwt-email"
      option :public_key, nil
      option :uid_claim, 'email'
      option :required_claims, %w(name email)
      option :info_map, { "name" => "name", "email" => "email" }

      def request_phase
        redirect options.auth_url
      end

      def callback_url
        full_host + script_name + callback_path
      end

      # decode token using SHA-256 hash algorithm and private/public key pair
      def decoded
        public_key = OpenSSL::PKey::RSA.new(options.public_key.to_s.gsub('\n', "\n"))
        @decoded ||= (JWT.decode request.params['jwt'], public_key, true, { :algorithm => 'RS256' }).first

        # check whether token has expiration time and is not expired
        raise ClaimInvalid.new("Token has expired.") unless Time.now.to_i < @decoded.fetch('exp', 0)

        # check whether token contains unique identifier
        raise ClaimInvalid.new("Missing required jti claim.") unless @decoded.key?('jti')

        # check for required claims
        (options.required_claims || []).each do |field|
          raise ClaimInvalid.new("Missing required '#{field}' claim.") unless @decoded.key?(field.to_s)
        end

        @decoded
      end

      def callback_phase
        super
      rescue ClaimInvalid => e
        fail! :claim_invalid, e
      end

      uid{ decoded[options.uid_claim] }

      extra do
        {:raw_info => decoded}
      end

      info do
        options.info_map.inject({}) do |h,(k,v)|
          h[k.to_s] = decoded[v.to_s]
          h
        end
      end
    end
  end
end
