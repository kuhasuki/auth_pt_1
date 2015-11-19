class SessionsController < ApplicationController

before_action :logged_in?, except: :destroy

  def new
    render :new
  end

  def create
    @user = User.find_by_credentials(
    params[:user][:user_name],
    params[:user][:password]
  )
    if @user.nil?
      #flash incorrect password/username combination
      flash.now[:errors] = ["invalid credentials"]
      render :new
    else
      #initiate a new session
      login!(@user)
      redirect_to cats_url
    end
  end

  def destroy
    if current_user
      current_user.reset_session_token!
      session[:session_token] = nil
      redirect_to new_session_url
    end
  end


end
