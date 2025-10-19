class CreateUsersTable < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string :username, null: false
      t.string :email, null: false
      t.string :password_digest, null: false
      t.text :fitness_stats
      t.string :avatar_url
      t.timestamps
      
      t.index :username, unique: true
      t.index :email, unique: true
    end
  end
end