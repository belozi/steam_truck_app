class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|
      t.string :project_title
      t.integer :user_id
      t.text :description
      t.text :problem
      t.text :solution
      t.text :status

      t.timestamps
    end
    add_index :projects, [:user_id, :created_at]
  end
end
 