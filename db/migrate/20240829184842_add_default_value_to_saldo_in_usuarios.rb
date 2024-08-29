class AddDefaultValueToSaldoInUsuarios < ActiveRecord::Migration[7.1]
  def change
    change_column :usuarios, :saldo, :decimal, precision: 10, scale: 2, default: 0.00, null: false
  end
end
