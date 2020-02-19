class UsersController < ApplicationController
  before_action :logged_in_user, except: %i(new create)
  before_action :correct_user,   only: [:edit, :update]
  before_action :admin_user,     only: :destroy
  before_action :find_user, except: %i(new index create)

  def index
    @users = User.paginate(page: params[:page])
  end

  def edit; end

  def show
    @user = User.find(params[:id])
    @microposts = @user.microposts.paginate(page: params[:page])
    return if @user
    flash[:alert] = t ".not_found"
    redirect_to root_path
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params
    if @user.save
      @user.send_activation_email
      flash[:info] = t ".pls_check_email"
      redirect_to root_url
    else
      flash[:alert] = t ".fails"
      render :new
    end
  end

  def update
    if @user.update user_params
      flash[:success] = t ".up_success"
      redirect_to @user
    else
      flash[:alert] = t ".up_fail"
      render :edit
    end
  end

  def destroy
    if @user.destroy
      flash[:alert] = t ".success_del"
      redirect_to users_url
    else
      flash.now[:alert] = t ".cant_destroy"
    end
  end

  private

  def user_params
    params.require(:user).permit :name, :email, :password,
                                 :password_confirmation
  end

  def logged_in_user
    return if logged_in?

    store_location
    flash[:danger] = t ".pleas_lg"
    redirect_to login_url
  end

  def correct_user
    @user = User.find(params[:id])
    redirect_to(root_url) unless current_user?(@user)
  end

  def admin_user
    return if current_user.admin?

    flash[:alert] = t ".not_adminn"
  end

  def find_user
    @user = User.find_by id: params[:id]
    return if @user
    flash[:alert] = t "user.destroy.not_find"
    redirect_to users_path
  end
end
