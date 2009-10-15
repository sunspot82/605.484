require 'rubygems'
require 'net/http'
require 'net/https'

#****************************************************************
#
# The DeliciousConnector class is implemented using the Singleton
# pattern. This object connects to Delicious web site user 
# account and retrieves their bookmarks.
#
#****************************************************************
class DeliciousConnector

public
#****************************************************************
#
# PUBLIC METHODS
#
#****************************************************************

  #****************************************************************
  # Retrieves the Delicious posts for a certain user/password pair.
  #****************************************************************
  def self.get_posts(user,password,query = "/v1/posts/recent?count=50")
    http = Net::HTTP.new('api.del.icio.us',443)
    #puts http.inspect
    http.use_ssl = true;
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE # added to remove warning message
    http.start do |http|    
      xml = get_authenticated(query,http,user,password)
      xml # Return value
    end
  end

  #****************************************************************
  # Return the HTML content of a web address.
  #****************************************************************
  def self.displayContent(address)    
    fetch(address)
    #puts "URL: #{url}"    
    #if url.scheme.eql?('http')
    #   req = Net::HTTP::Get.new(url.path)    
       #puts "Request: #{req}"
    #   res = Net::HTTP.start(url.host,url.port) do |http|      
    #      http.request(req);      
    #   end
       #puts "Response: #{res}"
    #   res.body
    #else
    #   client = HTTPClient.new
    #   resp = client.get(url)
    #   resp.content
    #end
  end

private
#****************************************************************
#
# PRIVATE METHODS
#
#****************************************************************
  #****************************************************************
  # Retreives Web page content.  Works for redirects as well has 
  # ssl connections.
  #****************************************************************
  def self.fetch(address, limit = 10)    
    raise ArgumentError, 'HTTP redirect too deep' if limit == 0
    #modify address string, if necessary.
    address = address.gsub(/\s/,'%20')
    address = address.gsub(/\|/,'%7C')
    url = URI.parse(address)
    #puts "url: #{url}"
    #puts url.inspect
    http=Net::HTTP.new(url.host, url.port)
    if ( url.scheme.eql?('https') )
       http.use_ssl = true
       http.verify_mode = OpenSSL::SSL::VERIFY_NONE # added to remove warning message
    end
    # Adjust path string if necessary.
    path = "/"
    path = url.path if url.path && ! url.path.empty?
    path += "?"+url.query if url.query
    #puts "url.path: #{url.path.inspect}"
    #puts "url.query: #{url.query.inspect}"
    #puts "path: '#{path}'"
    response = http.start() {|http|
       req = Net::HTTP::Get.new(path)
       http.request(req)
    }
    #puts response
    case response
    when Net::HTTPSuccess then response.body
    when Net::HTTPRedirection then
       if ( response['location'].match(/^http/))
          redirectAddr = response['location']
       else
          redirectAddr = url.scheme+"://"+url.host+":"+url.port.to_s+response['location']      
       end
       #puts "Redirected To: #{redirectAddr}"
       fetch(redirectAddr, limit - 1)
    else
       response.error!
    end
  end
  #****************************************************************
  # Authenticates a user/password pair for connecting to a valid 
  # Delicious Account.
  #****************************************************************
  def self.get_authenticated(path,http,user,password)
    request = Net::HTTP::Get.new(path,{'User-Agent' => 'JHU-RAILS - XYZ'})    
    request.basic_auth user,password
    response = http.request(request)
    if(response.code != "200")
       puts "Warning bad response making authenticated delicious call #{response.code}"
       nil  # Return value
   end
   
   response.body if response.code=="200"
   
  rescue => e
    puts "Exception Authenticating '#{e}' .... please check your login or password"
    nil
  rescue Timeout::Error => etimeout
    puts "Timeout getting path #{path} #{etimeout} ...."
    nil
  end
  
#****************************************************************
# Making new method private which only allows instance of 
# DeliciousConnector to be created inside the class methods.
#****************************************************************
private_class_method :new 
  
end

#****************************************************************
# Main Method
#****************************************************************
if __FILE__ == $0  
  #DeliciousConnector::displayContent("http://www.discoverohio.com/")
  #DeliciousConnector::displayContent("https://jaxb.dev.java.net/")
  #DeliciousConnector::displayContent("http://games.espn.go.com/flb/leagueoffice?leagueId=46551&seasonId=2009")
  #DeliciousConnector::displayContent("http://hackaday.com/2008/09/18/web-server-on-a-business-card-part-1/")
  
  #DeliciousConnector::displayContent("http://www.vegas.com/tours/")
  #DeliciousConnector::displayContent("http://www.iloveny.com")
  #DeliciousConnector::displayContent("http://twitchhiker.wordpress.com/about-2/")
  #DeliciousConnector::displayContent("http://www.amtrak.com/")
  #(broken) DeliciousConnector::displayContent("http://akaimbatman.intelligentblogger.com/wordpress/archives/41")
  #DeliciousConnector::displayContent("http://www.traveltex.com/")
  #DeliciousConnector::displayContent("http://wikitravel.org/en/Main_Page")
  #DeliciousConnector::displayContent("http://www.instructables.com/ex/i/4B2364EAFDE4102880EC001143E7E506/")
  #DeliciousConnector::displayContent("http://twitchhiker.wordpress.com/about-2/")
  #DeliciousConnector::displayContent("http://www.sonomavalley.com/")
  #DeliciousConnector::displayContent("http://www.travel.com/")  
  #DeliciousConnector::displayContent("http://www.smartertravel.com/airfare/?source=google_st_xml_travel_websites&s_kwcid=travel%20websites|2637368122&taparam=ESTGoogleUS_K2312779_A953749462_NS")
  #DeliciousConnector::displayContent("http://www.tripology.com/?s_kwcid=travel%20websites|3928977161&gclid=CL6Mp4nLtZ0CFc5L5QodSHrIig")
  #DeliciousConnector::displayContent("http://www.delta.com/")  
  #DeliciousConnector::displayContent("http://www.ubuntu.com/")
  #DeliciousConnector::displayContent("http://visualize.us/")
  

  DeliciousConnector::displayContent("http://www.newzealand.com/travel/home/usa.cfm")
  DeliciousConnector::displayContent("http://www.mapquest.com/")
  DeliciousConnector::displayContent("http://www.orbitz.com/")
end