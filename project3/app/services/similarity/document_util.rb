require 'app/services/similarity/account'
require 'rubygems'
require 'hpricot'
require 'stemmer'
require 'yaml'

#****************************************************************
#
# A Utility Class used for manipulating Document
# This class implements the Singleton
#
#****************************************************************
class DocumentUtil
  include Stemmable

private
#****************************************************************
#
# PRIVATE METHOD
#
#****************************************************************

  #****************************************************************
  # DocumentUtil Construtor
  #****************************************************************
  def initialize(stop_word_file = 'app/services/similarity/resources/stop_words.yml')
    # load stop words
    # CLASS VARIABLE    
    @@stopWords = YAML::load_file(stop_word_file)
    #puts "#{@@stopWords.length} stop words loaded..."    
  end
  
  #****************************************************************
  #
  # CLASS VARIABLES
  #
  #****************************************************************
  @@instance = DocumentUtil.new    

public
#****************************************************************
#
# PUBLIC METHOD
#
#****************************************************************

  #****************************************************************
  # Gets an instance of DocumentUtil
  #****************************************************************
  def self.instance
     @@instance  
  end  
  
  #****************************************************************
  # Removes tags from an Hpricot Document.                       
  #**************************************************************** 
  def removeTags(document,tagList)
    tagList.each do |tag|
       document.search(tag).remove
    end    
  end
  #****************************************************************
  # Retrieves the text content of Hpricot Document.
  #****************************************************************
  def textOnly(document)
    document.search("text()")
  end
  #****************************************************************
  # Removes punctuation from a line.
  #****************************************************************
  def removePunctuation(line)
     line.to_s.gsub(/(^|\s+)[[:punct:]]+|[[:punct:]]{2,}|[[:punct:]]+(\s+|$)/,' ').strip   
  end  
  #****************************************************************
  # Build the Document Frequency Map for each term in a file.
  #****************************************************************
  def buildTermCountMap(filepath,useTermRoot = false)
     lineProc = lambda do |term,map,useTermRoot|
                   term.chomp!
                   term = term.stem if useTermRoot
                   if map.key?(term)
                      map[term] = map[term] + 1.0
                   else
                      map[term] = 1.0
                   end
                end
     # Process a YAML file.
     if ( File.extname(filepath).eql?(".yml") )
        #puts "building Df by yaml."
        buildDfMapFromYaml filepath, lineProc, useTermRoot
     else # Process a .txt file.
        #puts "building Df by txt."
        buildDfMapFromFile filepath, lineProc, useTermRoot
     end
  end
  #****************************************************************
  # Determines if a term is considered a 'Stop Word'.  
  #****************************************************************  
  def isStopWord(term)
    @@stopWords.include?(term) || term.length < 3
  end
  #****************************************************************
  # Builds the Term map with the occurrance counts for each term.
  # from a YAML file.
  #****************************************************************
  def buildDfMapFromYaml(filepath,lineproc,useTermRoot=false)
     map = Hash.new
     contentArr = YAML.load_file(filepath)
     contentArr.each do |content|
        content.text.each_line do |line|
           lineproc.call line,map,useTermRoot
        end
     end
     map
  end
  #****************************************************************
  # Builds the Term map with the occurrance counts for each term.
  #****************************************************************
  def buildDfMapFromFile(filepath,lineproc,useTermRoot=false)
     map = Hash.new
     IO.foreach(filepath) do |line|
        lineproc.call line,map,useTermRoot
     end
     map
  end
  #****************************************************************
  # Returns the dot product value between two documents based on 
  # the vector space model.
  #****************************************************************
  def getDotProduct(w1,w2)
     product = 0.0
     # Iterate over shorter list since missing values are considered 0
     if w2.size < w1.size
        temp = w2
        w2 = w1
        w1 = temp
     end     
     # Compute the dot product.
     w1.keys.each do |key|
        if w1.key?(key) && w2.key?(key)           
           product += w1[key] * w2[key]        
        end
     end
     product
  end
  #****************************************************************
  # Returns the square root of the sum of the squares.
  #****************************************************************
  def getNorm(wv)
     sqSum = 0   
     wv.keys.each do |key|
        sqSum += wv[key]**2.0        
     end     
     Math.sqrt(sqSum)
  end
#****************************************************************
# Making new method private which only allows instance of 
# DocumentUtil to be created inside the class method definitions.
#****************************************************************
  private_class_method :new
end
#****************************************************************
# Main Method
#****************************************************************
if __FILE__ == $0   
   #fileDoc = open("examples/resources/sample2.html") { |f| Hpricot(f) }
   #DocumentUtil::instance.removeTags fileDoc,["script","style"]
   #docText = DocumentUtil::instance.textOnly(fileDoc)
   #docText.each do |line|     
     # remove punctuation
   #  line = DocumentUtil::instance.removePunctuation line
   #  if ! line.empty?
   #     puts "-#{line}" 
   #  end
   #end
   #line = "\"??h?Hello....Theres' O'Brien....\""
   #puts "#{DocumentUtil::instance.removePunctuation line}"
   #t = "talking"
   #puts "#{DocumentUtil::instance.termRoot t}"
   #puts t   
   path = "app/services/similarity/resources/data/jhu_ninu.yml"
   DocumentUtil::instance.buildTermCountMap(path).each_pair do |key,val|
      puts "#{key} -> #{val}"
   end  
end