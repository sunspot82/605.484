require 'rubygems'
require 'hpricot'
require 'project1/src/document'
require 'project1/src/document_util'

#****************************************************************
# The DocumentSet class.  Represents a Set of Document objects.
#****************************************************************
class DocumentSet

#****************************************************************
#
# INSTANCE VARIABLES
#
#****************************************************************
  
  attr_reader :documentList # defining getter method  
  attr_reader :termInDocCountMap        # defining getter method  
 
#****************************************************************
#
# PUBLIC METHOD
#
#****************************************************************

  #****************************************************************
  # DocumentSet Constructor
  #****************************************************************
  def initialize    
    @documentList = Array.new    
    # Reference to every Term of every Document    
    @termInDocCountMap = Hash.new
    @dataPath = nil
  end  
  #****************************************************************
  # Returns Terms that have a document frequency of greatern than
  # 2 standard deviations from the mean.
  #****************************************************************
  def getOutliers(directoryPath,stdDeviationValue = 2.0,print=false)
     loadData directoryPath
     terms = Array.new
     # Iterate over index and
     #puts "Terms with Df > #{stdDeviationValue} std deviations from mean"
     if ( stdDeviationValue > 0.0 )
        @documentList.each do |document|
           document.termCountMap.keys.each do |term|              
              termStdDev = computeTermStandardDeviation(term)        
              # Add to list if high enough deviation.
              if termStdDev > stdDeviationValue
                 terms << term
                 puts "[term=#{term};std_dev=#{termStdDev}]" if print
              end
           end
        end
     end
     terms
  end
  #****************************************************************
  # Get similarity score for all documents.
  #****************************************************************
  def getSetSimilarity(directoryPath,print=false)
     loadData directoryPath
     scores = Hash.new
     for outer in 0...@documentList.length
        for inner in outer...@documentList.length
           if ! @documentList[outer].filepath.eql?(@documentList[inner].filepath)
              key = "[#{@documentList[outer].owner}]-to-[#{@documentList[inner].owner}]"
              scores[key] = getSimilarityScore(@documentList[outer],@documentList[inner])
              puts "#{key} = #{scores[key]}" if print
           end 
        end
     end
     scores
  end
  #****************************************************************
  # Gets similarity scores of all document compared to the 
  # documents of 'owner'.
  #****************************************************************
  def getSetSimilarityToOwner(directoryPath,owner,print=false)
     loadData directoryPath
     ownerDoc = Document.new(owner,nil)
     ownerDocCount = 0
     scores = Array.new
     # Create single document for 'owner'.
     @documentList.each do |doc|
        if doc.owner.eql?(owner)
           ownerDoc.addTermCounts(doc.termCountMap)
           ownerDocCount += 1
        end
     end
     ownerDoc.computeTotal
     # If owner exists, get scores.
     if ownerDocCount > 0
        # Remove owner's docs from total count.
        totalDocs = (@documentList.size - ownerDocCount) + 1
        # Sort the list based on value.
        scores = getScoresComparedToDoc(ownerDoc,totalDocs,print)
     end
     scores
  end

private
#****************************************************************
#
# PRIVATE METHODS
#
#****************************************************************  

  #****************************************************************
  # Determines if the document data needs to be loaded.
  #****************************************************************
  def loadData(directoryPath)
     if @dataPath == nil || ! @dataPath.eql?(directoryPath)
        buildDocumentSet(directoryPath)
        @dataPath = directoryPath
     end
  end
  #****************************************************************
  # Goes through a directory and builds a document list.
  #****************************************************************
  def buildDocumentSet(directoryPath)
     # clear data structures
     @documentList.clear
     @termInDocCountMap.clear       
     # Build Document List
     buildDocmentList directoryPath
     #puts "Document Count: #{@documentList.length}"        
  end
  #****************************************************************
  # Computes the similarity score between two documents.
  #****************************************************************
  def getSimilarityScore(d1,d2)   
     # Weight Vectors
     wv1 = getWeightVector d1
     wv2 = getWeightVector d2     
     # Compute Dot Product
     dotProduct = DocumentUtil::instance.getDotProduct(wv1,wv2)
     #puts "dotProduct: #{dotProduct}"
     # Compute Norm
     d1Norm = DocumentUtil::instance.getNorm(wv1)
     d2Norm = DocumentUtil::instance.getNorm(wv2)
     #puts "d1Norm: #{d1Norm}"
     #puts "d2Norm: #{d2Norm}"
     # Compute Similarity Score.
     if d1Norm * d2Norm == 0.0
        similarity = 0.0
     else
        similarity = dotProduct.quo( d1Norm * d2Norm )
     end
     #puts "Documents[#{d1.id} ~ #{d2.id}] = #{similarity}"
     similarity
  end
  #****************************************************************
  # Compute the weight vector (based on vector space model)
  #****************************************************************
  def getWeightVector(doc)
    weightVector = Hash.new
    doc.termCountMap.keys.each do |term|
       weightVector[term] = getTermWeight(term,doc.termCountMap[term],doc.totalTermOccurances)       
    end
    weightVector
  end
  #****************************************************************
  # Computes the weight of a term
  #****************************************************************
  def getTermWeight(term,termCount,totalTermsCount)          
     (termCount.quo(totalTermsCount)) * Math.log(@documentList.length / (1.0 + @termInDocCountMap[term]))  
  end
  #****************************************************************
  # Returns the user that the file 'path' corresponds too.
  #****************************************************************
  def getDocumentOwner(path)
    File.basename(path)[/(.)+[^(.txt)(.yml)]/]
  end
  #****************************************************************
  # Returns the standard deviation value for the term identified 
  # by the parameter.
  #****************************************************************
  def computeTermStandardDeviation(term)
     totalTfValue = 0.0
     # Computes the Expected Value.
     @documentList.each do |document|
        if document.termCountMap[term] != nil
           totalTfValue += document.termCountMap[term]
        end
     end     
     mean = totalTfValue / Float::induced_from(@termInDocCountMap[term])
     #puts "     mean: #{mean}"
     result = 0.0
     # Computes Standard deviation
     @documentList.each do |document|
        if document.termCountMap[term] != nil
           result += ((document.termCountMap[term] - mean)**2.0)
        end
     end
     Math.sqrt(result / Float::induced_from(@termInDocCountMap[term]))
  end  
  #****************************************************************
  # Calculate the tf for each term in current document
  #****************************************************************
  def createDocument(owner,path) 
     # Create document          
     document = Document.new(owner,path)      
     # Build Term Count Map for Document.
     document.termCountMap = DocumentUtil::instance.buildTermCountMap(path,true)
     document.computeTotal
     # Update term contained in document counts
     document.termCountMap.keys.each do |term|
        if @termInDocCountMap.key?(term)
           @termInDocCountMap[term] += 1.0
        else
           @termInDocCountMap[term] = 1.0
        end
     end     
     document
  end
  #****************************************************************
  # Returns list of similarity scores compared to Document 'base'
  #****************************************************************
  def getScoresComparedToDoc(base,totalDocuments,print=false)
     scores = Hash.new
     @documentList.each do |doc|
        if ! doc.owner.eql?(base.owner)
           scores[doc.owner] = getSimilarityScore(base,doc)
           puts "[#{base.owner}-to-#{doc.owner}] - #{scores[doc.owner]}" if print
        end
     end
     scores
  end
  #****************************************************************
  # Build a list of documents
  #****************************************************************
  def buildDocmentList(directoryPath)
     #puts "Enter Directory..."
     #puts "directoryPath: #{directoryPath}"
     Dir[directoryPath+"/*"].each do |path|
        #puts path
        if File.file?(path)           
          # Get owner           
          owner = getDocumentOwner(path)
        # Create document
          @documentList << createDocument(owner,path)
        elsif File::directory?(path)
           #puts "processing Directory"
           path += "/" if path.match(/[^\/]$/)
           path += "*"
           buildDocmentList("#{path}")
        end
     end
     #puts "Leave Directory..."
  end  
end
#****************************************************************
# Main Method
#****************************************************************
if __FILE__ == $0
  dset = DocumentSet.new  
  #dset.getSetSimilarity('project1/src/resources/data/other',true)
  #dset.getSetSimilarity('project1/src/resources/data/programming',true)
  dset.getSetSimilarityToOwner('project1/src/resources/data/other','sunspot82',true)
  #dset.getOutliers('project1/src/resources/data/programming',2.0,true)
end