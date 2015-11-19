class CatsController < ApplicationController

  before_action :my_cat?, only: [:edit, :update]
  def index
    @cats = Cat.all
    render :index
  end

  def show
    @cat = Cat.find(params[:id])
    render :show
  end

  def new
    if logged_in?
      @cat = Cat.new
      render :new
    else
      flash[:shitbox] = "You gotta be logged in to make cats, baby"
      redirect_to new_session_url
    end
  end

  def create
    intermediate_params = cat_params
    intermediate_params[:user_id] = current_user.id

    @cat = Cat.new(intermediate_params)
    if @cat.save
      redirect_to cat_url(@cat)
    else
      flash.now[:errors] = @cat.errors.full_messages
      render :new
    end
  end

  def edit
    @cat = Cat.find(params[:id])
    render :edit
  end

  def update
    @cat = Cat.find(params[:id])
    if @cat.update_attributes(cat_params)
      redirect_to cat_url(@cat)
    else
      flash.now[:errors] = @cat.errors.full_messages
      render :edit
    end
  end

  def my_cat?
    @cat = Cat.find(params[:id])
    redirect_to cats_url if current_user != @cat.owner
  end

  private

  def cat_params
    params.require(:cat)
      .permit(:age, :birth_date, :color, :description, :name, :sex)
  end
end
