class SessionsController < ApplicationController
  # Ação para criar a sessão (login)
  skip_before_action :verify_authenticity_token # Ignora verificação CSRF para API

  def create
    # Use user_params para acessar os parâmetros da requisição
    user_params = user_params()
  
    # Encontrar usuário e administrador usando os parâmetros corretos
    user = User.find_by(ra: user_params[:ra])
    admin = Admin.find_by(ra: user_params[:ra])
  
    if admin && admin.senha == user_params[:senha]
      render json: { status: 'success', message: "Bem-vindo, administrador!", user_type: 'admin' }, status: :ok
    elsif user && user.senha == user_params[:senha]
      render json: { status: 'success', message: "Bem-vindo, usuário!", user_type: 'user' }, status: :ok
    elsif user.nil? && admin.nil?
      render json: { message: "Usuário não encontrado" }, status: :unprocessable_entity
    else
      render json: { message: "Senha incorreta" }, status: :unprocessable_entity
    end
  end
  
  def debug_session
    render json: { session: session.to_hash }
  end

  private

  # Permite apenas os parâmetros permitidos para criar ou atualizar usuários
  def user_params
    params.require(:user).permit(:ra, :senha)
  end

  # Método esboço para obter o usuário atual
  def current_user
    if session[:user_type] == 'admin'
      @current_user ||= Admin.find_by(id: session[:user_id])
    else
      @current_user ||= User.find_by(id: session[:user_id])
    end
  end
  
  def authorize_admin!
    unless current_user.is_a?(Admin)
      render json: {status: 'fail', message: 'Acesso negado. Apenas administradores podem realizar esta ação.'}, status: :forbidden
    end
  end
end
