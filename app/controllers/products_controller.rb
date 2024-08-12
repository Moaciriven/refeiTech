class ProductsController < ApplicationController
  before_action :set_produto, only: [:qtde, :destroy, :admin_edit]

  # Ação para criar (adicionar) um novo produto
  def create
    @produtonew = Produto.new(produto_params)
    @produto = Produto.find_by(id: params[:id])

    if @produtonew.save
      render json: {status: 'success', message: 'Produto adicionado com sucesso', produto: @produto}, status: :created
    else
      render json: {status: 'fail', message: 'Erro ao adicionar produto', errors: @produto.errors.full_messages}, status: :unprocessable_entity
    end
  end

  # Ação para exibir a quantidade de um produto
  def qtde
    if @produto && @produto.qtde >= 0
      render json: {status: 'success', message: 'Quantidade disponível', qtde: @produto.qtde}, status: :ok
    else
      render json: {status: 'fail', message: 'Produto não encontrado ou quantidade inválida'}, status: :not_found
    end
  end

  # Ação para permitir que o administrador edite um produto
  def admin_edit
    if @produto.update(produto_params)
      render json: {status: 'success', message: 'Produto atualizado com sucesso', produto: @produto}, status: :ok
    else
      render json: {status: 'fail', message: 'Erro ao atualizar produto', errors: @produto.errors.full_messages}, status: :unprocessable_entity
    end
  end

  # Ação para remover um produto
  def destroy
    if @produto.destroy
      render json: {status: 'success', message: 'Produto removido com sucesso'}, status: :ok
    else
      render json: {status: 'fail', message: 'Erro ao remover produto'}, status: :unprocessable_entity
    end
  end

  private

  # Define o produto com base no ID fornecido nos parâmetros
  def set_produto
    @produto = Produto.find_by(id: params[:id])
  end

  # Permite apenas os parâmetros permitidos para criar ou atualizar produtos
  def produto_params
    params.require(:produto).permit(:nome, :preco, :qtde)
  end
end
