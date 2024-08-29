class User < ApplicationRecord
  self.table_name = 'usuarios' # Especifica o nome da tabela

  # Associação
  has_many :compras, foreign_key: 'usuario_ra'

  # Validações
  validates :ra, presence: true, uniqueness: true
  validates :senha, presence: true
  validates :saldo, presence: true,
                    numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 9999999999.99 }

<<<<<<< HEAD
=======
  def profile_picture
    # Retorne um URL ou caminho padrão ou uma lógica para obter a imagem do perfil
    "/images/default_profile_picture.png" # Exemplo de uma imagem padrão
  end

>>>>>>> 88ac1b4 (teste)
end
