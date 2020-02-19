class MicropostsController < ApplicationController
  before_action :logged_in_user, only: %i(create destroy)
  before_action :correct_user,   only: :destroy

  def create
    @micropost = current_user.microposts.build micropost_params
    if @micropost.save
      flash[:success] = t".create_micro"
      redirect_to root_url
    else
      render "static_pages/home"
    end
  end

  def destroy
    if @micropost.destroy
      flash[:success] = t".destroy_succes"
      redirect_to request.referrer || root_url
    else
      flash[:alert] = t".destroy_fail"
    end
  end



  private

    def micropost_params
      params.require(:micropost).permit(:content, :picture)
    end

    def correct_user
      @micropost = current_user.microposts.find_by(id: params[:id])
      if @micropost.nil?
        redirect_to root_url
        flash[:alert] = t".correct_micro"
      end
    end

end
