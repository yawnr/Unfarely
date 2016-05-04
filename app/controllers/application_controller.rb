class ApplicationController < ActionController::Base

  protect_from_forgery with: :exception

  helper_method :current_user, :logged_in?

  def current_user
    @current_user = User.find_by_session_token(session[:session_token])
  end

  def logged_in?
    !!current_user
  end

  def login(user)
    user.reset_token!
    session[:session_token] = user.session_token
    redirect_to(root_url)
  end

  def logout
    user = current_user
    session[:session_token] = nil
    # render json: user
    redirect_to(new_session_url)
  end

  def require_logged_in
    redirect_to(new_session_url) unless logged_in?
  end

end
