class AddCompletedToProjects < ActiveRecord::Migration[7.2]
  def change
    add_column :projects, :completed, :boolean, default: false, null: false
  end
end
