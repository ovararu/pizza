class ApplicationController < ActionController::Base
  protect_from_forgery
  
  helper :all
  helper_method :admin_signed_in?
  
  ActiveScaffold.set_defaults do |config|
    config.security.default_permission = false
  end
  
  layout :layout_by_resource
  
  def index
  end

protected

  # To handle devise layouts
  def layout_by_resource
    if devise_controller?
      "account"
    else
      "application"
    end
  end

  #  def active_scaffold_session_cleanup
  #    session.each do |k, v| 
  #      session[k] = v unless k.is_a?(String) && k=~ /^as:/
  #    end
  #  end
  
  # helper methods for admin
  def admin_signed_in?
    user_signed_in? && current_user.admin?
  end

  def authenticate_admin!
    unless admin_signed_in?
      flash[:notice] = "You are not an admin..."
      redirect_to root_url and return false
    end
  end

private

  def require_user
    unless current_user
      store_location
      flash[:notice] = t('flash.require_user')
      redirect_to new_user_session_url
      return false
    end
  end

  def require_no_user
    if current_user
      store_location
      flash[:notice] = t('flash.require_no_user')
      redirect_to welcome_url
      return false
    end
  end

  def require_admin
    unless current_user && current_user.admin?
      flash[:warning] = t("flash.require_admin")
      redirect_to root_url and return false
    end
  end

  def require_user
    unless current_user
      store_location
      flash[:notice] = t('flash.require_admin')
      redirect_to new_user_session_url
      return false
    end
  end

  def store_location
    puts "Store Location: #{request.fullpath}"
    session[:return_to] = request.fullpath
  end

  def redirect_back_or_default(default)
    redirect_to(session[:return_to] || default)
    session[:return_to] = nil
  end

end # ApplicationController
