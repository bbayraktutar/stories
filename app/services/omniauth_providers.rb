module OmniauthProviders
  def self.provider_data
    [
        {
            key: :facebook,
            name: 'Facebook',
            icon: 'fa-facebook-square'
        },
        {
            key: :twitter,
            name: 'Twitter',
            icon: 'fa-twitter-square'
        },
        {
            key: :google_oauth2,
            name: 'Google',
            icon: 'fa-google'
        }
    ]
  end

  def self.provider_count
    provider_data.count
  end

  def self.finish_auth_for(authentication)
    # are we doing any after actions?
  end

  def self.provider_data_for(provider)
    provider_data.find {|data| data[:key] == provider.to_sym}
  end

  def self.user_attributes_from_omniauth(omniauth)
    attribute_generator = OmniauthAttributeGenerator.new(omniauth)
    case omniauth['provider']
      when 'facebook'
        attribute_generator.facebook
      when 'twitter'
        attribute_generator.twitter
      when 'google_oauth2'
        attribute_generator.google_oauth2
      else
        raise 'Unknown Provider'
    end
  end

  class OmniauthAttributeGenerator
    attr_reader :omniauth

    def initialize(omniauth)
      @omniauth = omniauth
    end

    def facebook
      {
          email: omniauth['info']['email'],
          username: omniauth['info']['name']
      }
    end

    def twitter
      {
          email: omniauth['info']['email'],
          username: omniauth['info']['name'],
          description: omniauth['info']['description'],
          location: omniauth['info']['location']
      }
    end

    def google_oauth2
      {
          email: omniauth['info']['email'],
          username: omniauth['info']['name']
      }
    end

  end
end
