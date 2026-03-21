class CreateTasks < ActiveRecord::Migration[7.2]
  def change
    create_table :tasks do |t|
      t.string :name, null: false
      t.boolean :completed, default: false, null: false
      t.references :project, null: false, foreign_key: true

      t.timestamps
    end
  end
end
