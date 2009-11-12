require 'test/unit'
require 'project1/src/document_util'

#****************************************************************
# The DocumentUtil Test Case.
#****************************************************************
class DocumentUtilTest < Test::Unit::TestCase  
  
  #****************************************************************
  # Test the DocumentUtil::removeTags method
  #****************************************************************
  def test_tag_removal
    fileDoc = Hpricot("project1/test_cases/data/sample.html")
    DocumentUtil::instance.removeTags(fileDoc,["script"])
    assert_nil(fileDoc.at("script"))
  end  
  #****************************************************************
  # Test the DocumentUtil::removePunctuation method
  #****************************************************************
  def test_punctuation_removal
    lineBefore = "Hello There O'Brien?"
    lineAfter = "Hello There O'Brien"
    assert_equal(DocumentUtil::instance.removePunctuation(lineBefore), lineAfter)          
  end
  #****************************************************************
  # Test the DocumentUtil::isStopWord method
  #****************************************************************
  def testIsStopWord
    stopWord = "a"
    nonStopWord = "hello"
    assert_not_nil(DocumentUtil::instance.isStopWord(stopWord))
    assert_equal(DocumentUtil::instance.isStopWord(nonStopWord),false)
  end
  #****************************************************************
  # Test the DocumentUtil::textOnly method
  #****************************************************************
  def test_text_only
     s = "<html><head></head><body>Text Only Content</body></html>"    
     doc = Hpricot(s)
     text = DocumentUtil::instance.textOnly(doc)     
     assert_equal(text.text,"Text Only Content")
  end
  #****************************************************************
  # Test the DocumentUtil::buildDfMap method
  #****************************************************************
  def test_build_df_map
     map = DocumentUtil::instance.buildTermCountMap("project1/test/resources/map_file_sample.txt")
     assert_equal(map["term5"],5) 
     assert_equal(map["term1"],1)         
     assert_nil(map["?"])
  end
end