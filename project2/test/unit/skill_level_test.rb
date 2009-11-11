require 'test_helper'

class SkillLevelTest < ActiveSupport::TestCase
   fixtures :skill_levels
  
   test "invalid with empty attributes" do
     s = SkillLevel.new
     assert !s.valid?
     assert s.errors.invalid?(:name)     
   end
   test "name must be unique" do
      s1 = SkillLevel.find(:first)
      s2 = SkillLevel.new
      s2.name = s1.name
      # Negative Test
      assert ! s2.valid?
      assert s2.errors.invalid?(:name)
      # Positive Test
      s2.name = s2.name + " Master"
      assert s2.valid?
   end
end
