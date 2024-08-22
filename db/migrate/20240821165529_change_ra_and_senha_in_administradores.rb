class ChangeRaAndSenhaInAdministradores < ActiveRecord::Migration[7.1]
  def change
    change_column_null :administradores, :ra, false
    change_column_null :administradores, :senha, false
  end
end
