class CreateUsers < ActiveRecord::Migration[8.1]
  def change
    create_table :users do |t|
      t.string :first_name
      t.string :last_name
      t.string :email
      t.string :password_digest
      t.string :phone
      t.string :address
      t.string :city
      t.string :province
      t.string :postal_code

      t.timestamps
    end
  end
end
