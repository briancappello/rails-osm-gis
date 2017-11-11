class MicropostsController < ApplicationController

  before_action :require_auth, only: [:create, :destroy]
  before_action :current_user_post, only: [:destroy]

  def create
    @micropost = current_user.microposts.build(micropost_params)
    if @micropost.save
      flash[:success] = 'Post successfully added!'
      redirect_to root_path
    else
      @feed = current_user.microposts.paginate(page: params[:page])
      render 'static_pages/home'
    end
  end

  def destroy
    @micropost.destroy
    flash[:success] = 'Post successfully deleted!'
    redirect_to request.referrer || root_path
  end

  private
    def micropost_params
      params.require(:micropost).permit(:content)
    end

    def current_user_post
      @micropost = current_user.microposts.find_by(id: params[:id])
      redirect_to root_path if @micropost.nil?
    end
end
