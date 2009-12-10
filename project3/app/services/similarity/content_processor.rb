require 'yaml'
require 'app/services/similarity/document_set'
#require 'rubygems'
#require 'classifier'

#****************************************************************
# Processes Account information.  Computes metric data based on 
# a group of Accounts.
#****************************************************************
class ContentProcessor
  
  attr_reader :data_directory
  
  #****************************************************************
  # SocialNet Constructor.
  #****************************************************************
  def initialize(path="app/services/similarity/resources/data")     
     #@taggedContent = TaggedDocumentSet.new
     @data_directory = path
     @docSet = DocumentSet.new
     #loadAccounts
  end    
  #****************************************************************
  # Executes the process to load all the data needed for similarity value computation.
  #****************************************************************
  def process_content(user,contents)
     contentArr = Array.new
     contents.each do |content|
        contentArr << Content.new(nil,nil,clean_content(content))
     end
     persist_user_content_to_file(user,contentArr)
  end
  #****************************************************************
  # Prints all similarity scores based on the tag parameter.
  #****************************************************************
  def set_similarity(print = false, dataDir="app/services/similarity/resources/data")
    #values = getUserSimilarityByTag(tag)    
    if print
       puts "========================================"
       puts "Similarity scores for all Users."
       puts "========================================"
    end
    @docSet.get_set_similarity(dataDir,print)  
  end
  #****************************************************************
  # Prints the similarity of all users in regard to a given user
  # and a specific tag.
  #****************************************************************
  def similarity_to_user(user,print = false, dataDir="app/services/similarity/resources/data")
     values = @docSet.get_set_similarity_to_owner(dataDir,user).sort do |e1,e2|
                    e2[1]<=>e1[1]
                 end
     if print
        puts "=============================================="
        #puts "Similarity to user \"#{user}\" by tag['#{tag}']"
        puts "Similarity to user ['#{user}']"
        puts "=============================================="
        values.each do |key,value|
           puts "[#{key}] = #{value}" 
         end
      end
      values 
  end
  #****************************************************************
  # Returns a list of outlier terms based on standard deviation value.
  #****************************************************************
  def printOutlierTerms(stdDev = 2.0,dataDir="app/services/similarity/resources/data")
     puts "=============================================="
     puts "Terms with Standard Deviation > #{stdDev}"
     puts "=============================================="
     terms = @docSet.getOutliers dataDir,stdDev,true     
     if terms == nil || terms.empty?
        puts "-No 'terms' match the criteria."
     else
        puts "--------------------------"
        puts "#{terms.size} total terms."
     end
  end     
private
#****************************************************************
#
# PRIVATE METHODS
#
#****************************************************************   
  #****************************************************************
  # Clean content
  #****************************************************************
  def clean_content(content)          
     data = ""
     content.each do |line|
        text = line.to_s.strip        
           # Write non-empty lines to user file.
        if ! text.empty?
              #outputFile.puts text
           text = DocumentUtil::instance.removePunctuation text
           text = text.downcase
           text.split(/\b/).each do |term|
              if term.match(/\w/) && ! DocumentUtil::instance.isStopWord(term)
                 data += term + "\n"
              end
           end
        end
     end
     data
   end
  #****************************************************************
  # Writes User Posted Content to a File
  #****************************************************************
  def persist_user_content_to_file(user,content)
     userFile = @data_directory+"/#{user}.yml"
           # Remove user file if already present.
     #File.delete(userFile) if File.exists?(userFile)
     File.open(userFile,"w") do |outputFile|
        puts "Persisting content for '#{user}'"
        #outputFile.puts account.contentMap[tag].to_yaml  
        outputFile.puts content.to_yaml
     end
  end   
end
#****************************************************************
# Main Method
#****************************************************************
#if __FILE__ == $0  
  #processor = ContentProcessor.new    
  #processor.process_content 
#end