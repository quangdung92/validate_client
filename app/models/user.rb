class User < ActiveRecord::Base
  attr_accessible :email, :password, :phonenumber, :username
  validates :username, :password, :presence => true
end
