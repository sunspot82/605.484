class CreateResources < ActiveRecord::Migration
  def self.up
    create_table :resources do |t|
      t.references :engineer
      t.string :role

      t.timestamps
    end
  end

  def self.down
    drop_table :resources
  end
end
