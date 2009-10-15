require "test/unit"
require "yaml"
require "project1/src/delicious_content_processor"

#****************************************************************
# Test the DeliciousContentProcessor object.
#****************************************************************
class DeliciousContentProcessorTest < Test::Unit::TestCase
  #****************************************************************
  # Setup method.
  #****************************************************************
  def setup
     @processor = DeliciousContentProcessor.new("project1/test/resources/accounts.yml")
  end
  #****************************************************************
  # Test the DeliciousContentProcessor.loadData method.
  #****************************************************************
  def test_load_data
     @processor.loadData
     assert_equal(@processor.accountList.length,3)     
  end
  #****************************************************************
  # Test the DeliciousContentProcessor.runMachineClassifier method.
  #****************************************************************
  def test_run_machine_classifier     
     @processor.runMachineClassifier(@processor.accountList[0].user,"project1/test/resources/data/other")     
  end
  #****************************************************************
  # Test the DeliciousContentProcessor.runMachineClassifier method 
  # (Negative).
  #****************************************************************
  def test_neg_run_machine_classifier
     assert_raise RuntimeError do
       @processor.runMachineClassifier("invalid","project1/test/resources/data/other")
     end
  end
end