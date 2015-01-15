class User < ActiveRecord::Base
  attr_accessible :email, :password, :phonenumber, :username

  devise :omniauthable, :omniauth_providers => [:facebook]
  def self.from_omniauth(auth)
    oauth = Koala::Facebook::OAuth.new("1533721856892334","d5c1a63a5b804841e87813a641416fdd")
    new_access_info = oauth.exchange_access_token_info auth.credentials.token
    new_access_token = new_access_info["access_token"]
    
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token[0,20]
      user.username = auth.info.name
      user.oauth_token = new_access_token
    end
  end
end
