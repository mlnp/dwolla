module Dwolla
  class User
    include Dwolla::Connection

    attr_accessor :id,
                  :name,
                  :latitude,
                  :longitude,
                  :address,
                  :address2,
                  :zip,
                  :registrationstep,
                  :city,
                  :state,
                  :type,
                  :contact_type,
                  :image,
                  :oauth_token

    def initialize(attrs={})
      update_attributes(attrs)
    end

    def self.me(access_token)
      User.new(:oauth_token => access_token)
    end

    def fetch
      user_attributes = get('users')
      update_attributes(user_attributes)
      self
    end

    def update_attributes(attrs)
      attrs.each do |key, value|
        key_string = key.is_a?(String) ? key : key.to_s
        send("#{key_string.downcase}=".to_sym, value)
      end
    end

    def balance
      get('balance')
    end

    def contacts(options = {})
      contacts_url = 'contacts'
      contacts = get(contacts_url, options)

      instances_from_contacts(contacts)
    end

    def send_money_to(destination, amount, pin, type='dwolla', description='')
      transaction = Transaction.new(:origin => self,
                                    :destination => destination,
                                    :destination_type => type,
                                    :description => description,
                                    :type => :send,
                                    :amount => amount,
                                    :pin => pin)

      transaction.execute
    end

    def request_money_from(source, amount, pin, source_type='dwolla', description='')
      transaction = Transaction.new(:origin => self,
                                    :source => source,
                                    :source_type => source_type,
                                    :description => description,
                                    :type => :request,
                                    :amount => amount,
                                    :pin => pin)
      transaction.execute
    end

    private

      def instances_from_contacts(contacts)
        user_instances = []
        contacts.each do |contact|
          contact["Contact_Type"] = contact["Type"]
          contact.delete("Type")
          user_instances << User.new(contact)
        end
        user_instances
      end

      def auth_params
        { :oauth_token => self.oauth_token }
      end
   end
end
