require "test/unit"
require "project1/src/document"

#****************************************************************
# Test the Document object.
#****************************************************************
class DocumentTest < Test::Unit::TestCase
  #****************************************************************
  # Setup
  #****************************************************************
  def setup
    # nothing to do
    @doc1 = Document.new("test")    
  end  
  #****************************************************************
  # Test the Document.addTermCounts method
  #****************************************************************
  def test_add_term_counts    
    @doc1.addTermCounts({"term1" => 6,"term2" => 1,"term3" => 5})
    assert_equal(@doc1.termCountMap.size,3)
  end
  #****************************************************************
  # Test Document.computeTotal method.
  #****************************************************************
  def test_compute_total
     @doc1.addTermCounts({"term1" => 6,"term2" => 1,"term3" => 5})
     @doc1.computeTotal
     assert_equal(@doc1.totalTermOccurances,12)
  end  
end