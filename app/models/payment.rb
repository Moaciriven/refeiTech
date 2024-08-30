class Payment < ApplicationRecord
  # Associações 
  belongs_to :product, foreign_key: 'product_id'
  belongs_to :users, foreign_key: 'users_ra', primary_key: 'ra'
 
  # Validações
  validates :users_ra, presence: true
  validates :product_id, presence: true
  validates :date_payment, presence: true
end
