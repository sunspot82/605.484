require 'test_helper'

class ResourceTest < ActiveSupport::TestCase
  
  # Testing presence validations
  test "invalid with empty attributes" do
     r = Resource.new
     assert !r.valid?
     assert r.errors.invalid?(:role)
     assert r.errors.invalid?(:engineer_id)
     assert r.errors.invalid?(:attachment)
  end
  
  # Testing attachment validations
  test "attachment must be present" do
     r = Resource.new
     r.role = "Photo"
     r.engineer = Engineer.first
     # Negative Test
     assert ! r.valid?
     assert r.errors.invalid?(:attachment)
     # Positive Test
     r.attachment = File.new("public\\images\\rails.png","r")
     assert r.valid?
  end
  # Testing engineer_id validations
  test "engineer must exist" do
     r = Resource.new
     r.role = "Role no one has yet."
     r.attachment = File.new("public\\images\\rails.png","r")
     # Negative Test
     r.engineer_id = -1
     assert !r.valid?
     assert r.errors.invalid?(:engineer_id)
     assert_equal('Engineer provided does not exist!',r.errors.on(:engineer_id))
     # Positive Test
     r.engineer = Engineer.first
     assert r.valid?
  end
end
