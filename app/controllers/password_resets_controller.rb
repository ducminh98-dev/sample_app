class PasswordResetsController < ApplicationController
  before_action :get_user,         only: [:edit, :update]
  before_action :valid_user,       only: [:edit, :update]
  before_action :check_expiration, only: [:edit, :update]

  def new; end

  def create
    @user = User.find_by(email: params[:password_reset][:email].downcase)
    if @user
      @user.create_reset_digest
      @user.send_password_reset_email
      flash[:info] = ".send_mess"
      redirect_to root_url
    else
      flash.now[:danger] = ".danger_mail"
      render :new
    end
  end

  def edit; end


  def update
    if params[:user][:password].empty?
      @user.errors.add(:password, "can't be empty")
      render :edit
    elsif @user.update_attributes(user_params)
      log_in @user
      flash[:success] = t".success_reset_pass"
      redirect_to @user
    else
      render :edit
    end
  end


  private

  def user_params
    params.require(:user).permit :password, :password_confirmation
  end


  def get_user

    @user = User.find_by email: params[:email]
  end

  def valid_user
    unless  @user&.activated? && @user&.authenticated?(:reset, params[:id])
      flash[:alert] = t".unvalid"
      redirect_to root_url
    end
  end

  def check_expiration
    if @user.password_reset_expired?
      flash[:danger] = t".check"
      redirect_to new_password_reset_url
    end
  end
end
