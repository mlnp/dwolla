module Dwolla
  class Transaction
    include Dwolla::Connection

    ENDPOINTS = { :send => 'transactions/send',
                  :request => 'transactions/request' }

    attr_accessor :origin, :destination, :destination_type, :type, :amount, :pin, :id, :source, :source_type, :description

    def initialize(attrs = {})
      attrs.each do |key, value|
        send("#{key}=".to_sym, value)
      end
    end

    def execute
      self.id = post(ENDPOINTS[type], to_payload)
    end

    private

      def auth_params
        { :oauth_token => origin.oauth_token }
      end

      def to_payload
        payload = {
          :amount => amount,
          :pin => pin
        }
        payload[:destinationId] = destination if destination
        payload[:destinationType] = destination_type if destination_type
        payload[:sourceId] = source if source
        payload[:sourceType] = source_type if source_type
        payload[:notes] = description if description

        payload
      end
  end
end
