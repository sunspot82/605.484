require "test/unit"
require "project1/src/document_set"
require "project1/src/tagged_document_set"
#****************************************************************
# Test the DocumentSet object.
#****************************************************************
class TagggedDocumentSetTest < Test::Unit::TestCase
  
  #****************************************************************
  # Setup method.
  #****************************************************************
  def setup
     #setup
     @tdocSet = TaggedDocumentSet.new
     @tag = "programming"
  end
  #****************************************************************
  # Test the DocmentSet.getOutliers method. (Negative - bad path)
  #****************************************************************
  def test_neg_get_outliers
    @tdocSet.getOutliers @tag,"invalid/path"
    assert_equal(@tdocSet.contentMap[@tag].documentList.length,0)
    assert_equal(@tdocSet.contentMap[@tag].termInDocCountMap.size,0)
  end
  #****************************************************************
  # Test the DocumentSet.getOutliers method.
  #****************************************************************
  def test_get_outliers
     outliers = @tdocSet.getOutliers @tag,"project1/test/resources/data/other"
     # A list of terms
     assert(outliers)
  end
  #****************************************************************
  # Test the DocumentSet.getSetSimilarity method.
  #****************************************************************
  def test_get_set_similarity
     scores = @tdocSet.getSetSimilarity @tag,"project1/test/resources/data/other"
     # A list of similarity scores
     assert_equal(scores.length,3)
  end
  #****************************************************************
  # Test the DocumentSet.getSetSimilarity method.
  #****************************************************************
  def test_get_set_similarity
     scores = @tdocSet.getSetSimilarity @tag,"invalid/path"
     # A list of similarity scores
     assert_equal(scores.length,0)
  end
  #****************************************************************
  # Test the DocumentSet.getSetSimilarityToOwner method.
  #****************************************************************
  def test_get_set_similarity_to_owner
     scores = @tdocSet.getSetSimilarityToOwner @tag,"project1/test/resources/data/other","sunspot82"
     # A list of similarity scores.
     assert_equal(scores.length,2)
  end
  #****************************************************************
  # Test the DocumentSet.getSetSimilarityToOwner method (Negative).
  #****************************************************************
  def test_neg_get_set_similarity_to_owner
     scores = @tdocSet.getSetSimilarityToOwner @tag,"project1/test/resources/data/other","invalid_user"
     # A list of similarity scores.
     assert_equal(scores.length,0)
  end
end