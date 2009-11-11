class SkillLevel < ActiveRecord::Base
  has_many :engineers, :dependent => :nullify, :foreign_key => :skill_level_id  
  validates_presence_of :name
  validates_uniqueness_of :name
end
