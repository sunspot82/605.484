class Project < ActiveRecord::Base
  belongs_to :organization
  
  has_many :project_assignments, :dependent => :destroy
  has_many :engineers, :through => :project_assignments
  has_many :project_scopes, :through => :project_assignments
  
  validates_presence_of :name, :organization_id
  validates_uniqueness_of :name
  
  validate :organization_must_exist
  acts_as_taggable
protected
  def organization_must_exist
     begin
        Organization.find(organization_id)
     rescue ActiveRecord::RecordNotFound
        errors.add(:organization_id,"Organization provided does not exist!")
     end
  end
end
