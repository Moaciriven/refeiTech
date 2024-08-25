class Compras < ApplicationRecord
  self.table_name = 'compras' # Especifica o nome da tabela
  
  # Associações 
  belongs_to :produto, foreign_key: 'produtos_id'
  belongs_to :usuario, foreign_key: 'usuarios_ra', primary_key: 'ra'
 
  # Validações
  validates :usuarios_ra, presence: true
  validates :produtos_id, presence: true
  validates :data_compra, presence: true
end