class ProductsController < ApplicationController
  skip_before_action :verify_authenticity_token 
  before_action :set_produto, only: [:check_stock, :destroy, :update]

  def create
    @produto_new = Produtos.new(produto_params)
  
    if @produto_new.save
      render json: { status: 'success', message: 'Produto adicionado com sucesso', produto: @produto_new }, status: :created
    else
      render json: { status: 'fail', message: 'Erro ao adicionar produto', errors: @produto_new.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def index
    @produtos = Produtos.all
    render json: { status: 'success', produtos: @produtos }, status: :ok
  end

  def check_stock
    if @produtos
      render json: { status: 'success', message: 'Quantidade disponível', qtde: @produtos.qtde }, status: :ok
    else
      render json: { status: 'fail', message: 'Produto não encontrado' }, status: :not_found
    end
  end

  def update
    if @produtos.update(produto_params)
      render json: { status: 'success', message: 'Produto atualizado com sucesso', produto: @produtos }, status: :ok
    else
      render json: { status: 'fail', message: 'Erro ao atualizar produto', errors: @produtos.errors.full_messages }, status: :unprocessable_entity
    end
  end
  
  def destroy
    if @produtos && @produtos.destroy
      render json: { status: 'success', message: 'Produto removido com sucesso' }, status: :ok
    else
      render json: { status: 'fail', message: 'Erro ao remover produto ou produto não encontrado' }, status: :unprocessable_entity
    end
  end
  
  private

  def set_produto
    @produtos = Produtos.find_by(id: params[:id])
    unless @produtos
      render json: { status: 'fail', message: 'Produto não encontrado' }, status: :not_found
    end
  end
  
  def produto_params
    params.require(:product).permit(:nome, :preco, :qtde)
  end
end
