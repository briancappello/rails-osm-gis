class MicropostsController < ApplicationController

  before_action :require_auth, only: [:create, :destroy]

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

  end

  private
    def micropost_params
      params.require(:micropost).permit(:content)
    end
end
