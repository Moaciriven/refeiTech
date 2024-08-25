class Admin < ApplicationRecord
    self.table_name = 'administradores' # Especifica o nome da tabela

    validates :ra, presence: true, uniqueness: true
    validates :senha, presence: true
end