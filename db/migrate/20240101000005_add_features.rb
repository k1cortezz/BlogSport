class AddFeatures < ActiveRecord::Migration[7.0]
  def change
    create_table :comments do |t|
      t.text :content
      t.references :user, foreign_key: true
      t.references :post, foreign_key: true
      t.timestamps
    end

    add_column :users, :fitness_stats, :text
    add_column :posts, :image_url, :string
  end
end