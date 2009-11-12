class CreateProjectAssignments < ActiveRecord::Migration
  def self.up
    create_table :project_assignments do |t|
      t.date :start_date
      t.date :end_date
      t.integer :project_scope_id
      t.integer :engineer_id
      t.integer :project_id

      t.timestamps
    end
  end

  def self.down
    drop_table :project_assignments
  end
end
