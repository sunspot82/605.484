require 'yaml'
require 'project1/src/delicious_connector'
require 'project1/src/document_set'
require 'project1/src/account'
require 'project1/src/document_util'
require 'rubygems'
require 'classifier'

#****************************************************************
# Processes Account information.  Computes metric data based on 
# a group of Accounts.
#****************************************************************
class DeliciousContentProcessor
  attr_reader :accountList
  #****************************************************************
  # SocialNet Constructor.
  #****************************************************************
  def initialize(path="project1/src/resources/all_accounts.yml")     
     #@taggedContent = TaggedDocumentSet.new
     @docSet = DocumentSet.new
     @accountList = Array.new
     loadAccounts path     
  end
  #****************************************************************
  # Executes the process to load all the data needed for similarity value computation.
  #****************************************************************
  def loadData(dataDir="project1/src/resources/data")
     getUserPosts
     buildUserPostContent
     persistUserContentToFile dataDir
  end
  #****************************************************************
  # Prints all similarity scores based on the tag parameter.
  #****************************************************************
  def printUserSimilarity(dataDir="project1/src/resources/data")
    #values = getUserSimilarityByTag(tag)
    puts "========================================"
    puts "Similarity scores for all Users."
    puts "========================================"
    @docSet.getSetSimilarity(dataDir,true)  
  end
  #****************************************************************
  # Prints the similarity of all users in regard to a given user
  # and a specific tag.
  #****************************************************************
  def printUserSimilarityToUser(user,dataDir="project1/src/resources/data")
     values = @docSet.getSetSimilarityToOwner(dataDir,user).sort do |e1,e2|
                 e2[1]<=>e1[1]
              end
     puts "=============================================="
     #puts "Similarity to user \"#{user}\" by tag['#{tag}']"
     puts "Similarity to user ['#{user}']"
     puts "=============================================="
     values.each do |key,value|
        puts "[#{key}] = #{value}" 
     end  
  end
  #****************************************************************
  # Returns a list of outlier terms based on standard deviation value.
  #****************************************************************
  def printOutlierTerms(stdDev = 2.0,dataDir="project1/src/resources/data")
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
  #****************************************************************
  # Runs a Classifier to compare each user's content with the 
  # classifier's result.
  #****************************************************************
  def runMachineClassifier(trainerName,dataDir="project1/src/resources/data")
     puts "============================="
     puts "Running Bayes Classifier"
     puts "   -trainer(#{trainerName})"
     puts "============================="
     puts "Training...."
     classifier = getTrainedClassifier trainerName
     if ( classifier )
        # Classify all other user posts.
        puts "Begin Classifying..."
        #@tags.each do |tag|          
           Dir[dataDir+"/*"].each do |path|
              if File.file?(path)
                 begin
                    contents = YAML::load_file(path)
                    contents.each do |content|
                       begin 
                          classification = classifier.classify content.text           
                          isMatch = content.tag.downcase.match(classification.downcase)                
                          puts "   #{isMatch} - [user=#{content.user};url=#{content.url};tag=#{content.tag};classify=#{classification}]"
                       rescue => e
                          puts "[Warning]: Error during classify of Content[user=#{content.user};url=#{content.url};tag=#{content.tag}]"
                       end
                    end
                 rescue => e
                    puts "[Warning]: Failed to load contents of file '#{path}'."
                 end
              end
           end          
        #end              
     else
       raise "[Error]: Missing Trainer data files.  Invalid user '#{trainerName}' specified."
     end
     puts "Done." 
  end  
private
#****************************************************************
#
# PRIVATE METHODS
#
#****************************************************************  
  #****************************************************************
  # loads users specified in the file 'path'.
  #****************************************************************
  def loadAccounts(path)
     users = YAML::load_file(path)
     users.each_pair do |user,pwd|
        @accountList << Account.new(user,pwd)
     end      
  end
  #****************************************************************
  # Gets a user's post information associated with their Delicious account.
  #****************************************************************
  def getUserPosts
     threadForEachUser do |account|
        begin
           #puts "'#{account.user}' Started."
           posts = DeliciousConnector::get_posts(account.user,account.pwd)           
           account.post_doc = Hpricot(posts)  # Parse XML
           puts "'#{account.user}' Post List Loaded."
        rescue => e
           puts "[Warning]: Failed to retrieve posts for '#{account.user}' : [#{e}]" 
        end
     end     
  end
  #****************************************************************
  # Returns the tag value based on a post's tag string.
  #****************************************************************
  def getTag(tagString)
     retval = "other"
     tags = ["programming","travel","other"]
     tags.each do |tag|
        if tagString.downcase.match(/#{tag.downcase}/)
           retval = tag
        end
     end
     retval
  end
  #****************************************************************
  # Adds Content to an Account based on their posts.
  #****************************************************************
  def buildUserPostContent
     threadForUserPosts do |account,post|
        begin
           # Get HTML content
           tag = getTag(post.attributes['tag'])           
           content = createUserContent post.attributes['href'],
                                       tag,
                                       DeliciousConnector::displayContent(post.attributes['href'])
           account.addContent(content)
           #writeUserContentToFile user,post.attributes['href'],post.get_attribute('tag'),content           
        rescue => e
           puts "[Warning]: Failed to retrieve content at #{post.attributes['href']} for '#{account.user}' : [#{e}]"
        end
     end  
  end
  #****************************************************************
  # Process each user account in a single thread.
  #****************************************************************
  def forEachUser(list = nil)     
     list = @accountList if list == nil
     list.each do |account|
        yield account
     end
  end  
  #****************************************************************
  # Process each user account in a separate thread.
  #****************************************************************
  def threadForEachUser(list = nil)
     threadList = Array.new
     list = @accountList if list == nil
     list.each do |account|
        threadList << 
           Thread.new(account.user,account.pwd) do |user,pwd|
              yield account   
           end
     end    
     threadList.each do |aThread|
        begin
           aThread.join(nil)
        rescue Timeout::Error => e
           puts "[Warning]: Timeout Error.  #{e}" 
        end
     end 
  end  
  #****************************************************************
  # Processes each user's posts in a separate thread.
  #****************************************************************
  def threadForUserPosts(list = nil)     
     threadForEachUser(list) do |account|
        puts "Retrieving post content for '#{account.user}'...."                
        account.post_doc.search('posts/post').each do |post|              
           yield account,post
        end
        puts "'#{account.user}' Done."  
     end
  end
  #****************************************************************
  # Writes User Posted Content to a File
  #****************************************************************
  def persistUserContentToFile(dataDir)
     threadForEachUser do |account|
        #account.contentMap.keys.each do |tag|
        #userFile = @dataDir+"other/#{account.user}.yml"
        #   if tag.match(/programming/)
        #      userFile = @dataDir+"programming/#{account.user}.yml"
        #   elsif tag.match(/travel/)
        #      userFile = @dataDir+"travel/#{account.user}.yml"
        #   end
        userFile = dataDir+"/#{account.user}.yml"
           # Remove user file if already present.
        File.delete(userFile) if File.exists?(userFile)
        File.open(userFile,"a") do |outputFile|
           puts "Persisting content for '#{account.user}'"
           #outputFile.puts account.contentMap[tag].to_yaml  
           outputFile.puts account.contentArr.to_yaml
        end
        #end
     end
  end
  #****************************************************************
  # Writes the content of a post to a file.
  #****************************************************************
  def createUserContent(url,tag,content)          
     #puts "content: #{content}"
     document = Hpricot(content)              
     DocumentUtil::instance.removeTags document,["style","script"]
     docText = DocumentUtil::instance.textOnly document       
     # Write contents for user out to a file...     
     #puts "Write content for user to file..."
     #File.open(userFile,"a") do |outputFile|
     data = "" 
     docText.each do |line|
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
     #end
     Content.new(url,tag,data)
  end
  #****************************************************************
  # Returns a bayes classifier.
  #****************************************************************
  def getTrainedClassifier(trainerName,dataDir="project1/src/resources/data")
     # Create Classifier
     classifier = nil
     # Train Classifier     
     #@tags.each do |tag|
       Dir[dataDir+"/*"].each do |path|
          if path.match(/#{trainerName}\.yml/)
             classifier = Classifier::Bayes.new("programming","travel","other") if classifier == nil          
             contents = YAML::load_file(path)
             contents.each do |content|
                if content.tag.match(/programming/)
                   #puts "Training in programming..."
                   classifier.train_programming content.text   
                elsif content.tag.match(/travel/)
                   #puts "Training in travel..."
                   classifier.train_travel content.text
                else
                   #puts "Training in other..."
                   classifier.train_other content.text
                end
             end
          end
       end
     #end     
     classifier
  end
end
#****************************************************************
# Main Method
#****************************************************************
if __FILE__ == $0
  
  processor = DeliciousContentProcessor.new  
  puts "Accounts Loaded: #{processor.accountList.length}"
  processor.loadData
  
  # Feature Set 1
  puts "************************"
  puts "* Feature Set 1...     *"
  puts "************************"
  puts "This computation may take several minutes..."  
  processor.printUserSimilarity
  #processor.printUserSimilarity("travel")
  #processor.printUserSimilarity("other")
  
  processor.printOutlierTerms
  #processor.printOutlierTerms "travel"
  #processor.printOutlierTerms "other"
  
  # Feature Set 2
  puts "************************"
  puts "* Feature Set 2...      *"
  puts "************************"
  puts "This computation may take several minutes..."
  processor.printUserSimilarityToUser "sunspot82"
  #processor.printUserSimilarityToUserByTag "sunspot82","travel"
  #processor.printUserSimilarityToUserByTag "sunspot82","other"
  
  # Feature Set 3
  puts "************************"
  puts "* Feature Set 3...     *"
  puts "************************"
  puts "This computation may take several minutes..."
  processor.runMachineClassifier "sunspot82"   
end