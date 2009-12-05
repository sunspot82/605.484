class CreateNames < ActiveRecord::Migration
  def self.up
    create_table :names do |t|
      t.string :fname
      t.string :lname
      t.references :engineer

      t.timestamps
    end
    
    add_index :names, :fname
    add_index :names, :lname
  end
  
  def self.down
    drop_table :names
  end
end
