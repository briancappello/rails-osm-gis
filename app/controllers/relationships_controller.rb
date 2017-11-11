class RelationshipsController < ApplicationController

  before_action :require_auth

  def create
    @user = User.find(params[:followed_id])
    current_user.follow(@user)
    respond_to do |fmt|
      fmt.html {
        flash[:success] = "You are now following #{@user.name}"
        redirect_to user_path(@user)
      }
      fmt.js
    end

  end

  def destroy
    @user = Relationship.find(params[:id]).followed
    current_user.unfollow(@user)
    respond_to do |fmt|
      fmt.html {
        flash[:success] = "You have stopped following #{@user.name}"
        redirect_to user_path(current_user)
      }
      fmt.js
    end
  end

end
