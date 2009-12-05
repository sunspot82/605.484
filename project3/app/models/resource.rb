class Resource < ActiveRecord::Base
  belongs_to :engineer
  has_attached_file :attachment,
                           :whiny => false,
                           :styles => { :thumb => "32x32>",
                                             :small => "100x100>" }
  validates_presence_of :role,:engineer_id  
  validates_attachment_presence :attachment
  
  validate :valid_resume_content_type
  validate :engineer_exists
  
protected  
  #
  # Only allow for resume resource to be of text/plain content type.
  #
  def valid_resume_content_type
     if ! role.nil? && role.casecmp("resume") == 0     
        if attachment_content_type.nil? || attachment_content_type.casecmp("text/plain") != 0
           errors.add(:attachment,"Resume must be a plain text file.")
        end
     end
   end
   #
   # Verify that the engineer exists.
   #
   def engineer_exists
     if ! Engineer.exists?(["id = ?",engineer_id])     
        errors.add(:engineer_id,"Engineer provided does not exist!")
     end
   end   
end
