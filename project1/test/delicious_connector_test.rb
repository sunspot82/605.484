require "test/unit"
require 'yaml'
require 'project1/src/delicious_connector'

#****************************************************************
# Test the DeliciousConnector object.
#****************************************************************
class DeliciousConnectorTest < Test::Unit::TestCase  
  #****************************************************************
  # Test the DeliciousConnector::get_posts method.
  #****************************************************************
  def test_get_posts
     users = YAML::load_file("project1/test/resources/accounts.yml")
     begin
        posts = DeliciousConnector::get_posts(users.keys[0],users[users.keys[0]])
        assert(posts)
     rescue Timeout::Error => e      
     end
  end
  #****************************************************************
  # Test the DeliciousConnector::get_posts method (Negative).
  #****************************************************************
  def test_neg_get_posts
     # connecting with invalid user.
     posts = DeliciousConnector::get_posts("invalid","invalid")
     assert_nil(posts)
  end
  #****************************************************************
  # Test the DeliciousConnector::displayContent method.
  #****************************************************************
  def test_display_content
     begin
        content = DeliciousConnector::displayContent("http://www.yahoo.com")
        assert(content)
     rescue Timeout::Error => e      
     end
  end
  #****************************************************************
  # Test the DeliciousConnector::displayContent method (Negative).
  #****************************************************************
  def test_neg_display_content
     begin
       DeliciousConnector::displayContent("invalid.address")
       flunk "Invalid web address, exception should have been thrown!"
     rescue => e
       assert(true)
     end
  end
end