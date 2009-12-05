class CreateSimilarityScores < ActiveRecord::Migration
  def self.up
    create_table :similarity_scores do |t|
      t.integer :engineer_id_1
      t.integer :engineer_id_2
      t.float :score

      t.timestamps
    end
  end

  def self.down
    drop_table :similarity_scores
  end
end
