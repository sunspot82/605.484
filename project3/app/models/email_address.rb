class EmailAddress < ActiveRecord::Base
  belongs_to :engineer
  
  validates_presence_of :label, :address, :engineer_id
  validates_format_of :address, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i, :on => :create
  def to_s
     "#{address} (#{label})"  
  end
end
