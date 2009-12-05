class SimilarityScore < ActiveRecord::Base
  validates_presence_of :engineer_id_1, :engineer_id_2, :score
  validates_numericality_of :score, :greater_than_or_equal_to => 0
  
  validate :engineers_must_exist
protected

   def engineers_must_exist
      if ! Engineer.exists?(["id = ?",engineer_id_1])
         errors.add(:engineer_id_1, "Engineer 1 does not exist!")
      end
      if ! Engineer.exists?(["id = ?",engineer_id_2])
         errors.add(:engineer_id_2, "Engineer 2 does not exist!")
      end 
   end
end
