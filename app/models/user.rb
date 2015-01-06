class User < ActiveRecord::Base
  attr_accessible :email, :password, :phonenumber, :username
end
