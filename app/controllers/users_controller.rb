class UsersController < ApplicationController
before_action :logged_in?
  def new
    if current_user
      redirect_to cats_url
    else
      render :new
    end
  end

  def create
    @user = User.new(user_params)
    if @user.save
      flash[:success] = "You have successfully created #{@user.user_name}"
      login!(@user)
      redirect_to cats_url #'cats/index'
    else
      flash[:errors] = "You dun goofed"
      render :new
    end
  end

  private

  def user_params
    params.require(:user).permit(:user_name, :password)
  end

end
