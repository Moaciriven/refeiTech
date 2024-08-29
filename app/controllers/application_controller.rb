class ApplicationController < ActionController::Base
  # Supondo que você tenha um método para encontrar o usuário logado, como:
  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  helper_method :current_user
end
