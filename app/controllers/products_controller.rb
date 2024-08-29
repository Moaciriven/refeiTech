class ProductsController < ApplicationController
  skip_before_action :verify_authenticity_token 
  before_action :set_produto, only: [:check_stock, :destroy, :update]

  def create
    @produto_new = Produtos.new(Produtos.permitted_params(params))
  
    if @produto_new.save
      render json: { status: 'success', message: 'Produto adicionado com sucesso', produto: @produto_new }, status: :created
    else
      render json: { status: 'fail', message: 'Erro ao adicionar produto', errors: @produto_new.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def index
    @produtos = Produtos.all
    @user_id = current_user.id if current_user
    render json: { status: 'success', produtos: @produtos }, status: :ok
  end

  def check_stock
    if @produto
      render json: { status: 'success', product: @produto, stock: @produto.qtde }, status: :ok
    else
      render json: { status: 'fail', message: 'Produto não encontrado' }, status: :not_found
    end
  end

  def update
    if @produto.update(Produtos.permitted_params(params))
      render json: { status: 'success', message: 'Produto atualizado com sucesso', produto: @produto }, status: :ok
    else
      render json: { status: 'fail', message: 'Erro ao atualizar produto', errors: @produto.errors.full_messages }, status: :unprocessable_entity
    end
  end
  
  def destroy
    if @produto && @produto.destroy
      render json: { status: 'success', message: 'Produto removido com sucesso' }, status: :ok
    else
      render json: { status: 'fail', message: 'Erro ao remover produto ou produto não encontrado' }, status: :unprocessable_entity
    end
  end
  
  private

  def set_produto
    @produto = Produtos.find_produto_by_id(params[:id])
  end
end
