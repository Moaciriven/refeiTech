class PaymentsController < ApplicationController
  skip_before_action :verify_authenticity_token # Ignora verificação CSRF para API

  # Mostra as opções de pagamento disponíveis
  def methods
    payment_methods = [
      { method: 'credit_card', name: 'Cartão de Crédito' },
      { method: 'pix', name: 'Pix' }
    ]
    render json: { status: 'success', payment_methods: payment_methods }, status: :ok
  end

  # Cria uma nova transação de pagamento
  def create
    payment_method = params[:payment_method]

    if payment_method == 'credit_card'
      if valid_credit_card?(params)
        # Simulação de processamento de pagamento com cartão de crédito
        # Aqui você integraria com um serviço de pagamento real
        render json: { status: 'success', message: 'Pagamento realizado com sucesso com Cartão de Crédito!' }, status: :ok
      else
        render json: { status: 'fail', message: 'Dados do cartão inválidos' }, status: :unprocessable_entity
      end
    elsif payment_method == 'pix'
      if valid_paypal?(params)
        # Simulação de processamento de pagamento via PayPal
        render json: { status: 'success', message: 'Pagamento realizado com sucesso com Pix' }, status: :ok
      else
        render json: { status: 'fail', message: 'Dados do Pix inválidos' }, status: :unprocessable_entity
      end
    else
      render json: { status: 'fail', message: 'Método de pagamento inválido' }, status: :unprocessable_entity
    end
  end

  private

  def valid_credit_card?(params)
    # Simulação de validação de dados do cartão de crédito
    params[:card_number].present? && params[:expiration_date].present? && params[:cvv].present?
  end

  def valid_pix?(params)
    # Simulação de validação de dados do PayPal
    params[:pix_key].present?
  end
end
