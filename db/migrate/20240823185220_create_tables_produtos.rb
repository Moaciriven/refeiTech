class CreateTablesProdutos < ActiveRecord::Migration[7.1]
  def change
    create_table :produtos do |t|
      t.string :nome, null: false
      t.decimal :preco, precision: 10, scale: 2, null: false
      t.integer :qtde
      t.timestamps
    end
  end
end
