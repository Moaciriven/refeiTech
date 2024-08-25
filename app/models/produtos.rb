class Produtos < ApplicationRecord
  self.table_name = 'produtos' # Especifica o nome da tabela

  # Associação
  has_many :compras, foreign_key: 'produtos_id'

  # Validações
  validates :nome, presence: true, length: {maximum: 100}
  validates :preco, presence: true, 
                    numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 9999999999.99 }
  validates :qtde, numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 100 }

end
