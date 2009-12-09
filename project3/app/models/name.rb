class Name < ActiveRecord::Base
  belongs_to :engineer
  
  validates_presence_of :fname, :lname
  
  validate :is_valid_name  
  
  def to_s
     fname + " " + lname
  end

protected
   # Verifies that name is unique.
   def is_valid_name
      if Name.exists?(['fname = ? AND lname = ?',fname,lname])
         errors.add(:name,'name already exists!') 
      end
   end
   # Verifies Engineer is valid.
  #def engineer_must_exist
  #   if ! Engineer.exists?(["id = ?",engineer_id])
  #      errors.add(:engineer_id,"Engineer referenced does not exist!")
  #   end
  #end 
end
