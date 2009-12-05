#****************************************************************
# A Content object.
#****************************************************************
class Content
  
  attr_reader :url
  attr_reader :tag
  attr_reader :text
  attr_accessor :user
  #****************************************************************
  # Content constructor
  #****************************************************************
  def initialize(url,tag,text)
     @url = url
     @tag = tag
     @text = text
     @user = nil
  end
end

#****************************************************************
# An Account object.
#****************************************************************
class Account
  attr_reader :user
  attr_reader :pwd
  attr_reader :fileMap
  attr_accessor :post_doc
  attr_accessor :contentArr
  
  #****************************************************************
  # Account Constructor
  #****************************************************************
  def initialize(user,pwd = '')
    @user = user
    @pwd = pwd
    @fileMap = Hash.new
    @post_doc = nil
    #@contentMap = Hash.new
    @contentArr = Array.new    
  end  
  #****************************************************************
  # Add url to user account.
  #****************************************************************
  def addContent(content)
    content.user = @user
    @contentArr = Array.new if @contentArr == nil
    @contentArr << content
  end  
end