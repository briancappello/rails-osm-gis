class SessionsController < ApplicationController

  def new
  end

  def create
    @user = User.find_by(email: params[:session][:email].downcase)
    if @user && @user.authenticate(params[:session][:password])
      login(@user)
      params[:session][:remember_me] == '1' ? remember(@user) : forget(@user)
      redirect_to user_path(@user)
    else
      # render isn't considered a new request, so need to use flash.now
      flash.now[:danger] = 'Invalid email or password.'
      render 'new'
    end
  end

  def destroy
    logout if logged_in?
    redirect_to root_path
  end

end
