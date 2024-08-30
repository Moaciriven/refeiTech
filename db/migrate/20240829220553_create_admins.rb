class CreateAdmins < ActiveRecord::Migration[7.1]
  def change
    create_table :admins do |t|
      t.string :ra, null: false
      t.string :password_digest, null: false

      t.timestamps
    end
  end
end
