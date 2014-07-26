class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.text :content
      t.integer :user_id
      t.integer :points, default: 0

      t.timestamps
    end

    add_index :posts, [:user_id, :created_at]

  end
end
