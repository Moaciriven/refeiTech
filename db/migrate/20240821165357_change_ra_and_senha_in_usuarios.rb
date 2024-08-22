class ChangeRaAndSenhaInUsuarios < ActiveRecord::Migration[7.1]
  def change
    change_column_null :usuarios, :ra, false
    change_column_null :usuarios, :senha, false
  end
end
