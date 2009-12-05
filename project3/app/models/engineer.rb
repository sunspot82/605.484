class Engineer < ActiveRecord::Base
  belongs_to :skill_level
  has_one :name, :dependent => :destroy, :validate => true
  has_many :projects, :through => :project_assignments
  has_many :project_scopes, :through => :project_assignments
  has_many :resources, :dependent => :destroy, :validate => true
  
  validates_presence_of :years_of_experience, :skill_level_id
  validates_numericality_of :years_of_experience, :greater_than_or_equal_to => 0
  
  #validate :is_valid_experience
  validate :skill_level_must_exist
  
  acts_as_taggable
protected
  # Verifies Skill Level is valid.
  def skill_level_must_exist
     begin
        level = SkillLevel.find(skill_level_id)       
     rescue ActiveRecord::RecordNotFound
        errors.add(:skill_level_id, 'Skill Level provided does not exist!')
     end
  end
end
