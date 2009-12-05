class CreateEngineers < ActiveRecord::Migration
  def self.up
    create_table :engineers do |t|
      t.integer :years_of_experience
      t.references :skill_level

      t.timestamps
    end
    add_index :engineers, :years_of_experience
  end

  def self.down
    drop_table :engineers
  end
end
