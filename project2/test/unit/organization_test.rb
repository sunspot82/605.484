require 'test_helper'

class OrganizationTest < ActiveSupport::TestCase
  fixtures :organizations
  test "invalid with empty attributes" do
     o = Organization.new
     assert !o.valid?
     assert o.errors.invalid?(:name)     
   end
   test "name must be unique" do
      o1 = Organization.find(:first)
      o2 = Organization.new
      o2.name = o1.name
      # Negative Test
      assert ! o2.valid?
      assert o2.errors.invalid?(:name)
      # Positive Test
      o2.name = o2.name + " 2.0"
      assert o2.valid?
   end
end
