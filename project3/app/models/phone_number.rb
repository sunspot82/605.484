class PhoneNumber < ActiveRecord::Base
  belongs_to :engineer
  
  validates_presence_of :label, :number
  # 
  # Phone number regular expression found at url:
  #
  # http://regexlib.com/DisplayPatterns.aspx?cattabindex=6&categoryId=7
  # 
  validates_format_of :number, :with => /^(1\s*[-\/\.]?)?(\((\d{3})\)|(\d{3}))\s*[-\/\.]?\s*(\d{3})\s*[-\/\.]?\s*(\d{4})\s*(([xX]|[eE][xX][tT])\.?\s*(\d+))*$/, :on => :create
  def to_s
     "#{number} (#{label})"   
  end
end
