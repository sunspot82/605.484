class CreateProjectAssignments < ActiveRecord::Migration
  def self.up
    create_table :project_assignments do |t|
      t.date :start_date
      t.date :end_date
      t.references :engineer
      t.references :project
      t.references :project_scope

      t.timestamps
    end
  end

  def self.down
    drop_table :project_assignments
  end
end
