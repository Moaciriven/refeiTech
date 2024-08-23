class CreateTablesCompras < ActiveRecord::Migration[7.1]
  def change
    create_table :compras do |t|
      t.string :usuarios_ra, null: false   
      t.references :produtos, foreign_key: true  

      t.timestamps
    end

  add_foreign_key :compras, :usuarios, column: :usuarios_ra, primary_key: :ra
  
  end

end
  