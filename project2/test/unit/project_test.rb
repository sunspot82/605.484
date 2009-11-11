require 'test_helper'

class ProjectTest < ActiveSupport::TestCase
  
  fixtures :projects, :organizations
  
  test "invalid with empty attributes" do
     p = Project.new
     assert !p.valid?
     assert p.errors.invalid?(:name)
     assert p.errors.invalid?(:organization_id)
   end
   
   # Testing name validations
   test "name must be unique" do
      p1 = Project.find(:first)
      p2 = Project.new
      p2.name = p1.name
      p2.organization_id = Organization.find(:first).id
      # Negative Test
      assert ! p2.valid?
      assert p2.errors.invalid?(:name)
      # Positive Test
      p2.name = p2.name + " 2.0"
      assert p2.valid?
   end
   
   test "organization must exist" do
      p = Project.new
      p.name = "Unique Project Name"
      # Negative Test
      p.organization_id = -1
      assert ! p.valid?
      assert p.errors.invalid?(:organization_id)
      assert_equal 'Organization provided does not exist!', p.errors.on(:organization_id)
      # Positive Test
      p.organization_id = Organization.find(:first).id
      assert p.valid?
   end
end
