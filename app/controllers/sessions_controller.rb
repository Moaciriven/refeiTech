class SessionsController < ApplicationController
  # Ação para criar a sessão (login)
  skip_before_action :verify_authenticity_token # Ignora verificação CSRF para API
  def create
    user = User.find_by(ra: params[:ra])
    admin = Admin.find_by(ra: params[:ra])

    if admin && admin.senha == params[:password]
      render json: { status: 'success', message: "Bem-vindo, administrador!", user_type: 'admin' }, status: :ok
    elsif user && user.senha == params[:password]
      render json: { status: 'success', message: "Bem-vindo, usuário!", user_type: 'user' }, status: :ok
    elsif user.nil? && admin.nil?
      render json: { message: "Usuário não encontrado" }, status: :unprocessable_entity
    else
      render json: { message: "Senha incorreta" }, status: :unprocessable_entity
    end
  end
  private

  # Permite apenas os parâmetros permitidos para criar ou atualizar usuários
  def user_params
    params.require(:user).permit(:ra, :nome, :senha)
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
