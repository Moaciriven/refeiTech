class CreateTablesAdmin < ActiveRecord::Migration[7.1]
  def change
    create_table :administradores do |t|
        t.string :ra
        t.string :senha
        t.timestamps
      end
    end
  end