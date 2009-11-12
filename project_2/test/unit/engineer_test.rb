require 'test_helper'

class EngineerTest < ActiveSupport::TestCase  
  fixtures :skill_levels, :engineers
  
  def setup
     @skill_level_id = SkillLevel.find(:first).id
  end
  
  test "invalid with empty attributes" do
     e = Engineer.new
     assert !e.valid?
     assert e.errors.invalid?(:name)
     assert e.errors.invalid?(:years_of_experience)
     assert e.errors.invalid?(:skill_level_id)
  end
  
  # Testing name validations
  test "name must be unique" do
     e1 = Engineer.find(:first)
     e2 = Engineer.new
     e2.name = e1.name
     e2.years_of_experience = 0
     e2.skill_level_id = @skill_level_id
     
     # Negative Test
     assert ! e2.valid?
     assert e2.errors.invalid?(:name)
     
     # Positive Test
     e2.name = e1.name + " differentLastName"
     assert e2.valid?
  end
  
  # Testing years_of_experience validations
  test "experience can not be negative" do
     e = Engineer.new
     e.name = "Fred Savage"
     e.skill_level_id = @skill_level_id
     
     # Negative Test
     e.years_of_experience = -1
     assert ! e.valid?
     assert e.errors.invalid?(:years_of_experience)
     assert_equal 'Experience can not be negative.', e.errors.on(:years_of_experience)
     # Positive Test
     e.years_of_experience = 1
     assert e.valid?     
   end
   
   # Testing Skill_level_id validations
   test "Skill Level must exist" do
      e = Engineer.new
      e.name = "Terry Allen"
      e.years_of_experience = 0
      # Negative Test
      e.skill_level_id = -1
      assert !e.valid?
      assert e.errors.invalid?(:skill_level_id)
      assert_equal 'Skill Level provided does not exist!', e.errors.on(:skill_level_id)
      # Positive Test
      e.skill_level_id = @skill_level_id
      assert e.valid?
   end
end