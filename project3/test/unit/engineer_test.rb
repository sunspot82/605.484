require 'test_helper'

class EngineerTest < ActiveSupport::TestCase 
  
  # Setup method
  def setup     
     @engineer = Engineer.first
     @engineer.name = Name.first
     @engineer.skill_level = SkillLevel.first
     @engineer.name.lname = "#{@engineer.name.lname} JR."
  end
   
  # Empty Engineer Test
  test "invalid with empty attributes" do
     e = Engineer.new
     assert !e.valid?
     assert e.errors.invalid?(:years_of_experience) 
     assert e.errors.invalid?(:skill_level_id)
   end
   
  # Testing years_of_experience validations
  test "experience can not be negative" do         
     # Negative Test
     @engineer.years_of_experience = -1
     assert ! @engineer.valid?
     assert @engineer.errors.invalid?(:years_of_experience)
     
     # Positive Test
     @engineer.years_of_experience = 1
     assert @engineer.valid?     
   end
   
   # Testing Skill_level_id validations
   test "Skill Level must exist" do      
      
      # Negative Test
      @engineer.skill_level_id = -1
      assert !@engineer.valid?
      assert @engineer.errors.invalid?(:skill_level_id)
      assert_equal 'Skill Level provided does not exist!', @engineer.errors.on(:skill_level_id)
      
      # Positive Test
      @engineer.skill_level = SkillLevel.first
      assert @engineer.valid?
   end
end