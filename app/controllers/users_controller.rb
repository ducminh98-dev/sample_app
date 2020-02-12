class UsersController < ApplicationController
  before_action :logged_in_user, only: [:index,:edit, :update, :destroy]
  before_action :correct_user,   only: [:edit, :update]
  before_action :admin_user,     only: :destroy

  def new
    @user = User.new
  end


  def edit
    @user = User.find_by id: params[:id]
  end

  def show
    @user = User.find_by id: params[:id]
    return if @user
    flash[:alert] = t ".not_found"
    redirect_to root_path
  end



  def create
    @user = User.new user_params
    if @user.save
      log_in @user
      flash[:success] = t ".success"
      redirect_to  @user
    else
      flash[:alert] = t".fails"
      render :new
    end
  end


  def destroy
    User.find(params[:id]).destroy
    flash[:success] = t ".del_succes"
    redirect_to root_url
  end


  def update
    @user =User.find_by id: params[:id]
    if @user.update_attributes(user_params)
      flash[:success] = t ".up_success"
      redirect_to @user
    else
      flash[:alert] = t ".up_fail"
      render :edit
    end
  end


  def index
   @users = User.paginate(page: params[:page])
  end




  private

  def user_params
    params.require(:user).permit :name, :email, :password,
                                 :password_confirmation
  end

  def logged_in_user
    unless logged_in?
       store_location
      flash[:danger] = t ".pleas_lg"
      redirect_to login_url
    end
  end


  def correct_user
  @user = User.find(params[:id])
      redirect_to(root_url) unless @user == current_user
  end



    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end


end
