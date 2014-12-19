class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :email, null: false
      t.string :username, null: false
      t.string :password_digest, null: false
      t.string :tg_auth_token, null: false
      t.datetime :last_login

      t.index :email, unique: true
      t.index :username, unique: true

      t.timestamps
    end
  end
end
