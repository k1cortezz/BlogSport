class CreateNotifications < ActiveRecord::Migration[7.0]
  def change
    create_table :notifications do |t|
      t.references :user, foreign_key: true
      t.references :actor, foreign_key: { to_table: :users }
      t.references :notifiable, polymorphic: true
      t.string :action
      t.datetime :read_at
      t.timestamps
    end

    add_column :comments, :parent_id, :integer
    add_index :comments, :parent_id
  end
end