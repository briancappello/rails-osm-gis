class SessionsController < ApplicationController

  def new
    if (user = current_user)
      flash[:success] = 'You are already logged in.'
      redirect_to(user)
    end
  end

  def create
    @user = User.find_by(email: params[:session][:email].downcase)
    if @user && @user.authenticate(params[:session][:password])
      login(@user)
      params[:session][:remember_me] == '1' ? remember(@user) : forget(@user)
      redirect_to_remembered_or user_path(@user)
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
