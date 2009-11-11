class CreateEngineers < ActiveRecord::Migration
  def self.up
    create_table :engineers do |t|
      t.string :name      
      t.integer :years_of_experience
      t.integer :skill_level_id

      t.timestamps
    end
  end

  def self.down
    drop_table :engineers
  end
end
