class ProjectScope < ActiveRecord::Base
  has_many :project_assignments, :dependent => :nullify
  validates_presence_of :name
  validates_uniqueness_of :name
end
