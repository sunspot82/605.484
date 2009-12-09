require 'test_helper'

class NameTest < ActiveSupport::TestCase
  fixtures :engineers, :skill_levels
  
  def setup
     @engineer = Engineer.first
  end
  # Empty test
  test "empty name" do
     n = Name.new     
     assert !n.valid?
     assert n.errors.invalid?(:fname)
     assert n.errors.invalid?(:lname)     
  end
  # Testing name validations
  test "name must be unique" do
     n1 = Name.find(:first)     
     n2 = Name.new(:fname => n1.fname, :lname => n1.lname, :engineer_id => @engineer.id)
     
     # Negative Test
     assert ! n2.valid?
     assert n2.errors.invalid?(:name)
     
     # Positive Test
     n2 = Name.new(:fname => "HiThere", :lname => "differentLastName", :engineer_id => @engineer.id)
     assert n2.valid?
  end
  # Test engineer validates
  #test "engineer must exist" do
    # n = Name.new(:fname => "first", :lname => "last")    
     #Negative Test
     #n.engineer_id = -1
    # assert ! n.valid?
    # assert n.errors.invalid?(:engineer_id)
     
     #Positive Test
    # n.engineer_id = @engineer.id
    # assert n.valid?     
 # end
end
