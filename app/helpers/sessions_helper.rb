module SessionsHelper

  def require_auth
    unless logged_in?
      flash[:danger] = 'Please log in.'
      remember_redirect_to
      redirect_to login_url
    end
  end

  def require_correct_user
    @user = User.find(params[:id])
    redirect_to(root_url) unless current_user?(@user)
  end

  def require_admin
    unless current_user.admin?
      flash[:danger] = 'Forbidden action.'
      redirect_to root_url
    end
  end

  def current_user
    if (user_id = session[:user_id])
      @current_user ||= User.find_by(id: user_id)
    elsif (user_id = cookies.signed[:user_id])
      user = User.find_by(id: user_id)
      if user && user.authenticated?(cookies[:remember_token])
        login user
        @current_user = user
      end
    end
    @current_user
  end

  def current_user?(user)
    return false if user.nil? or current_user.nil?
    user == current_user
  end

  def logged_in?
    !!current_user
  end

  def login(user)
    # session cookies are encrypted by default, but note regular cookies are NOT
    session[:user_id] = user.id
  end

  def logout
    forget(current_user)
    session.delete(:user_id)
    @current_user = nil
  end

  def remember(user)
    cookies.permanent.signed[:user_id] = user.id
    cookies.permanent[:remember_token] = user.remember
  end

  def forget(user)
    user.forget
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end

  def remember_redirect_to
    session[:redirect_to] = request.original_url if request.get?
  end

  def redirect_to_remembered_or(default)
    redirect_to(session[:redirect_to] || default)
    session.delete(:redirect_to)
  end

end
