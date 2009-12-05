class ProjectAssignment < ActiveRecord::Base
  belongs_to :engineer
  belongs_to :project
  belongs_to :project_scope
  
  validates_presence_of :start_date, :end_date, :engineer_id, :project_id, :project_scope_id

  validate :project_exists, :project_scope_exists, :engineer_exists, :start_date_before_end_date
protected
  #
  # Verify Project is valid.
  #
  def project_exists
     begin
        Project.find(project_id)
     rescue ActiveRecord::RecordNotFound
        errors.add(:project_id,"Project provided does not exist!")
     end
   end
   #
   # Verify Project Scope is valid.
   #
   def project_scope_exists
     begin
        ProjectScope.find(project_scope_id)
     rescue ActiveRecord::RecordNotFound
        errors.add(:project_scope_id,"Project Scope provided does not exist!")
     end
   end
   #
   # Verify Engineer is valid.
   #
   def engineer_exists
     begin
        Engineer.find(engineer_id)
     rescue ActiveRecord::RecordNotFound
        errors.add(:engineer_id,"Engineer provided does not exist!")
     end
   end
   #
   # Verify Start Date is before the End Date.
   #
   def start_date_before_end_date
      if ( start_date != end_date && start_date > end_date)
         errors.add(:start_date,'Start Date must be before End Date!')
         errors.add(:end_date,'End Date must be after Start Date!')
      end
   end
end

