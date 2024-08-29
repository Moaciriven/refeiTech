class ChangeSaldoDefaultInUsuarios < ActiveRecord::Migration[7.1]
  def change
    change_column_default :usuarios, :saldo, from: nil, to: 0.0

  end
end
