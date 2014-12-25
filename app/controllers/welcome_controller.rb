class WelcomeController < ApplicationController
  def index
    @usernames = User.find(:all, :select => "username")
    @phones = User.find(:all, :select => "phonenumber")
    @emails = User.find(:all, :select => "email")
  end
  
  def create
    @user = User.create(:username => params[:username], :password => params[:password],
                        :email => params[:email], :phonenumber => params[:phonenumber])
                        logger.debug "user: #{@user.username}"
                        logger.debug "pass: #{@user.password}"
                        logger.debug "phone: #{@user.phonenumber}"
    if @user
      redirect_to welcome_index_path
    else
      render 'index'
    end
  end
end
