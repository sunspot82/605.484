require 'test_helper'

class ProjectAssignmentTest < ActiveSupport::TestCase
  
  def setup
     @pa = ProjectAssignment.new
     @pa.engineer_id = Engineer.find(:first).id
     @pa.project_id = Project.find(:first).id
     @pa.project_scope_id = ProjectScope.find(:first).id
     @pa.start_date = Date.today
     @pa.end_date   = Date.today
   end
   
  # Testing presence valids
  test "invalid with empty attributes" do
     pa = ProjectAssignment.new
     # Negative Test
     assert !pa.valid?
     assert pa.errors.invalid?(:start_date)
     assert pa.errors.invalid?(:end_date)
     assert pa.errors.invalid?(:engineer_id)
     assert pa.errors.invalid?(:project_id)
     assert pa.errors.invalid?(:project_scope_id)
     # Positive Test
     assert @pa.valid?
  end
  
  # Testing date order validations
  test "start must be before end date" do
     # Positive Test
     assert @pa.valid?
     
     #Negative Test
     @pa.end_date = @pa.start_date
     # five days after end_date
     @pa.start_date = @pa.start_date + 5 
     assert ! @pa.valid?
     assert @pa.errors.invalid?(:start_date)
     assert_equal('Start Date must be before End Date!',@pa.errors.on(:start_date))
          
  end
  # Testing engineer_id validations
  test "engineer must exist" do
     # Positive Test
     assert @pa.valid?
     
     #Negative Test
     @pa.engineer_id = -1
     assert ! @pa.valid?
     assert @pa.errors.invalid?(:engineer_id)
     assert_equal('Engineer provided does not exist!',@pa.errors.on(:engineer_id))
  end
  # Testing project_id validations
  test "project must exist" do
     # Positive Test
     assert @pa.valid?
     
     #Negative Test
     @pa.project_id = -1
     assert ! @pa.valid?
     assert @pa.errors.invalid?(:project_id)
     assert_equal('Project provided does not exist!',@pa.errors.on(:project_id))
  end
  # Testing project_scope_id validations
  test "project scope must exist" do
     # Positive Test
     assert @pa.valid?
     
     #Negative Test
     @pa.project_scope_id = -1
     assert ! @pa.valid?
     assert @pa.errors.invalid?(:project_scope_id)
     assert_equal('Project Scope provided does not exist!',@pa.errors.on(:project_scope_id))
  end
end
