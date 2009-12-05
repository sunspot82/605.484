require 'app/services/similarity/document_set'
#****************************************************************
# Adapter class for organizing a set of DocumentSet objects based
# on a tag value.
#****************************************************************
class TaggedDocumentSet
  
  attr_reader :contentMap
  
  #****************************************************************
  # TaggedContent Constructor
  #****************************************************************
  def initialize
    @contentMap = Hash.new
  end
  #****************************************************************
  # Returns a list of outlier terms for content associated with
  # the 'tag' parameter.
  #****************************************************************
  def getOutliers(tag, directoryPath, stdDeviationValue = 2.0, print=false)
     @contentMap[tag] ||= DocumentSet.new
     @contentMap[tag].getOutliers(directoryPath,stdDeviationValue,print)
  end
  #****************************************************************
  # Returns a list of similarity scores for content
  # tagged 'tag'.
  #****************************************************************
  def getSetSimilarity(tag,directoryPath,print=false)
     @contentMap[tag] ||= DocumentSet.new
     @contentMap[tag].getSetSimilarity(directoryPath,print)
  end
  #****************************************************************
  # Returns a list of similarity scores for content
  # tagged 'tag' with respect to a specific document owner.
  #****************************************************************
  def getSetSimilarityToOwner(tag,owner,directoryPath,print=false)
     @contentMap[tag] ||= DocumentSet.new
     @contentMap[tag].getSetSimilarityToOwner(owner,directoryPath,print)
  end
end