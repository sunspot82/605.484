class Engineer < ActiveRecord::Base
  has_many :project_assignments, :dependent => :destroy
  has_many :projects, :through => :project_assignments
  has_many :resources, :dependent => :destroy
  
  belongs_to :skill_level
  belongs_to :user
  validates_presence_of :name, :years_of_experience, :skill_level_id
  validates_uniqueness_of :name
  validates_numericality_of :years_of_experience, :skill_level_id
  
  validate :experience_greater_than_zero
  validate :skill_level_must_exist
  
  acts_as_taggable
  
protected
  def experience_greater_than_zero
     if ! years_of_experience.nil? && years_of_experience < 0
        errors.add(:years_of_experience, 'Experience can not be negative.')
     end
   end
  def skill_level_must_exist
     begin
        level = SkillLevel.find(skill_level_id)       
     rescue ActiveRecord::RecordNotFound
        errors.add(:skill_level_id, 'Skill Level provided does not exist!')
     end
  end
end
