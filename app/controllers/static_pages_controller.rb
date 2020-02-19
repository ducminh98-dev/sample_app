class StaticPagesController < ApplicationController

  def home
    if logged_in?
      @micropost = current_user.microposts.build
      @feed_items = Micropost.by_autor(current_user.id).paginate(page: params[:page])
    end
    else
    @feed_items = []
    end
  end

  def help; end

  def about; end

  def contact; end

end
