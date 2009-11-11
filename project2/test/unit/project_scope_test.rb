require 'test_helper'

class ProjectScopeTest < ActiveSupport::TestCase
   fixtures :project_scopes
  
   test "invalid with empty attributes" do
     ps = ProjectScope.new
     assert !ps.valid?
     assert ps.errors.invalid?(:name)     
   end
   test "name must be unique" do
      ps1 = ProjectScope.find(:first)
      ps2 = ProjectScope.new
      ps2.name = ps1.name
      # Negative Test
      assert ! ps2.valid?
      assert ps2.errors.invalid?(:name)
      # Positive Test
      ps2.name = ps2.name + " II"
      assert ps2.valid?
   end
end
