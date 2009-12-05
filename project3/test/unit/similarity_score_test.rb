require 'test_helper'

class SimilarityScoreTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  def setup
     @score = SimilarityScore.first
     e_arr = Engineer.find(:all,:limit=>2)
     @score.engineer_id_1 = e_arr[0].id
     @score.engineer_id_2 = e_arr[1].id
  end
  # Test Empty Score
  test "score must not be empty" do
     score = SimilarityScore.new
     assert ! score.valid?
     assert score.errors.invalid?(:engineer_id_1)     
     assert score.errors.invalid?(:engineer_id_2)
     assert score.errors.invalid?(:score)
  end
  # Test Score value
  test "score must be numeric" do
     # Negative Test
     @score.score = -1
     assert ! @score.valid?
     assert @score.errors.invalid?(:score)
     
     # Positive Test
     @score.score = 0
     assert @score.valid?
  end
  # Test Engineer Existence
  test "Engineers must exist" do
     e1 = @score.engineer_id_1
     e2 = @score.engineer_id_2
     
     # Negative Test
     @score.engineer_id_1 = -1     
     assert ! @score.valid?
     assert @score.errors.invalid?(:engineer_id_1)     
     
     # Negative Test 2
     @score.engineer_id_2 = -1     
     assert ! @score.valid?
     assert @score.errors.invalid?(:engineer_id_2)
     
     
     # Positive Test
     @score.engineer_id_1 = e1
     @score.engineer_id_2 = e2
     assert @score.valid?
  end
end
