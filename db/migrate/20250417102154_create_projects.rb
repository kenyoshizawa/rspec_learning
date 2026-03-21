class CreateProjects < ActiveRecord::Migration[7.2]
  def change
    create_table :projects do |t|
      t.string :name, null: false
      t.text :description
      t.date :due_on
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
    add_index :projects, [ :name, :user_id ], unique: true
  end
end
