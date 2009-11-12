class Resource < ActiveRecord::Base
  belongs_to :engineer
  has_attached_file :f,
                           :whiny => false,
                           :styles => { :thumb => "32x32>",
                                             :small => "100x100>" }
  validates_presence_of :engineer_id, :role
  validates_attachment_presence :f  
  validate :engineer_exists
protected

  def engineer_exists
     begin
        Engineer.find(engineer_id)
     rescue ActiveRecord::RecordNotFound
        errors.add(:engineer_id,"Engineer provided does not exist!")
     end
   end
end
