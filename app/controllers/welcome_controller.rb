class WelcomeController < ApplicationController
  def index
  end

  def check
    @username = User.find_by_username(params[:username])
    respond_to do |format|
      format.json { render :json => !@username }
    end
  end

  def checkavailable
    phonenumber = params[:phonenumber]
    email = params[:email]
    if phonenumber == ""
    phone = nil
    mail = email
    elsif email == ""
      mail = nil
      phone = phonenumber
        else
        mail = email
        phone = phonenumber
    end
    logger.debug "phone: #{ phone}"
    logger.debug "phonenumber: #{ phonenumber}"
    @acc = User.find_by_email_and_phonenumber(mail,phone)
    respond_to do |format|
      format.json { render :json => !@acc, status: :ok }
    end
  end

  def create
    @user = User.create(:username => params[:username], :password => params[:password],
                        :email => params[:email], :phonenumber => params[:phonenumber])
    if @user
      sleep(4.0)
      redirect_to root_path
    else
    end
  end
end
