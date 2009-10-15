#****************************************************************
#
# A Document object.
#
#****************************************************************
class Document
#****************************************************************
#
# CLASS VARIABLES
#
#****************************************************************
  
#****************************************************************
#
# INSTANCE VARIABLES
#
#****************************************************************
  attr_reader   :filepath # defining getter method  
  attr_reader   :owner    # defining getter method  
  attr_accessor :termCountMap    # defining getter/setter method  
  attr_reader   :totalTermOccurances # defining getter method
public
#****************************************************************
#
# PUBLIC METHODS
#
#****************************************************************

  #****************************************************************
  # Document Constructor
  #****************************************************************
  def initialize(owner = nil,filepath = nil)
    @filepath = filepath
    @owner = owner
    #@terms = Array.new
    @termCountMap = Hash.new
    @totalTermOccurances = 0.0
  end
  #****************************************************************
  # Prints some information about this Document.
  #****************************************************************
  def print
    puts "owner: #{owner}"
    puts "filepath: #{filepath}"    
  end
  #****************************************************************
  # Computes the total of term occurances
  #****************************************************************
  def computeTotal
     @totalTermOccurances = 0.0
     @termCountMap.values.each do |count|
        @totalTermOccurances += count     
     end
  end  
  #****************************************************************
  # Adds a term counts to this document.
  #****************************************************************
  def addTermCounts(termCountMap)
    @termCountMap.merge!(termCountMap)
  end  
end

#****************************************************************
# Main Method
#****************************************************************
if __FILE__ == $0 
   d = Document.new "test","test/path"
   d.print
end