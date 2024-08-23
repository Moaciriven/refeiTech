class AddSaldoToUsuario < ActiveRecord::Migration[7.1]
  def change
    add_column :usuarios, :saldo, :decimal, precision: 10, scale: 2, null: false
  end
end
