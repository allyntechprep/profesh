class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      t.string :email
      t.string :password_digest
      t.string :occupation
      t.string :bio
      t.string :display_name
      t.string :employer
      t.string :aspiring_occupation

      t.timestamps
    end
  end
end
