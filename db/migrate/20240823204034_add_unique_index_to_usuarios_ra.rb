class AddUniqueIndexToUsuariosRa < ActiveRecord::Migration[7.1]
  def change
    add_index :usuarios, :ra, unique: true
  end
end
