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

  def destroy
    logout
    redirect_to root_url
  end

  def facebook_acc
    @graph = Koala::Facebook::GraphAPI.new(current_user.oauth_token)
    profile = @graph.get_object("me")
    @friends = @graph.get_connections("me", "taggable_friends?fields=id,name,picture.type(large)")
    @feeds = @graph.get_connections("me", "feed?fields=message&limit=2")
    logger.debug "friends #{@photo}"
  end

  def micropost
    @graph = Koala::Facebook::GraphAPI.new(current_user.oauth_token)
    @graph.put_connections("me", "feed", :message => params[:micropost])
    redirect_to welcome_facebook_acc_path
  end

  def delete_post
    @graph = Koala::Facebook::GraphAPI.new(current_user.oauth_token)
    @ids = params[:ids]
    @graph.delete_object(params[:ids])
    redirect_to welcome_facebook_acc_path
  end
  
  def image
  end
    
end
