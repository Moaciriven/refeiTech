class SessionsController < ApplicationController
  skip_before_action :verify_authenticity_token # Ignora verificação CSRF para API

  def create
    user = User.find_by(ra: params[:ra])
    admin = Admin.find_by(ra: params[:ra])
    
    if admin && admin.senha == params[:password]
      render json: {status: 'success', message: "Bem-vindo, administrador!" }, status: :ok
    elsif user && user.senha == params[:password]
      render json: {status: 'success', message: "Bem-vindo, usuário!" }, status: :ok
    elsif user.nil? && admin.nil?
      render json: {message: "Usuário não encontrado" }, status: :unprocessable_entity
    else
      render json: {message: "Senha incorreta" }, status: :unprocessable_entity
    end
  end
end

 