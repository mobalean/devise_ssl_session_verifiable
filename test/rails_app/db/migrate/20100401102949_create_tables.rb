class CreateTables < ActiveRecord::Migration
  def self.up
    create_table :admins do |t|
      ## Database authenticatable
      t.string :email,              :null => true
      t.string :encrypted_password, :null => true

      ## Recoverable
      t.string   :reset_password_token
      t.datetime :reset_password_sent_at

      ## Rememberable
      t.datetime :remember_created_at

      ## Token authenticatable
      t.string :authentication_token

      t.timestamps
    end
  end

  def self.down
    drop_table :admins
  end
end
