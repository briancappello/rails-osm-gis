class UsersController < ApplicationController

  before_action :require_auth, only: [:index,
                                      :edit, :update,
                                      :edit_password, :update_password]
  before_action :require_correct_user, only: [:edit, :update,
                                              :edit_password, :update_password]
  before_action :require_admin, only: [:destroy]

  def index
    @users = User.paginate(page: params[:page])
  end

  def show
    @user = User.find(params[:id])
    @microposts = @user.microposts.paginate(page: params[:page])
    @count = @user.microposts.count()
  end

  def new
    @user = User.new
  end

  def edit
    @user = User.find(params[:id])
  end

  def create
    @user = User.new(user_params)
    if @user.save
      login(@user)
      flash[:success] = 'Welcome to Sample App!'
      redirect_to @user
    else
      render 'new'
    end
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(update_params)
      flash[:success] = 'Profile successfully updated!'
      redirect_to @user
    else
      render 'edit'
    end
  end

  def edit_password
    @user = User.find(params[:id])
  end

  def update_password
    @user = User.find(params[:id])
    current_pass = params[:user][:current_password]
    new_pass = params[:user][:password]

    if !@user.authenticate(current_pass)
      @user.errors.add(:current_password, 'is not valid')
    end

    if new_pass.blank?
      @user.errors.add(:password, 'is required')
    elsif new_pass == current_pass
      @user.errors.add(:password, 'must be different from your current password')
    end

    if @user.errors.empty? && @user.update_attributes(password_params)
      flash[:success] = 'Password successfully changed!'
      redirect_to edit_user_path(@user) and return
    end

    render 'edit_password'
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = 'User successfully deleted!'
    redirect_to users_path
  end

  private
    def user_params
      params.require(:user).permit(:name, :email,
                                   :password, :password_confirmation)
    end

    def update_params
      params.require(:user).permit(:name, :email)
    end

    def password_params
      params.require(:user).permit(:password, :password_confirmation)
    end
end
