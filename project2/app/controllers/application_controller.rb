# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base  
  helper :all # include all helpers, all the time  
 
  # Performs error checking for missing Records.
  def record_not_found
     begin
        yield
     rescue ActiveRecord::RecordNotFound
       logger.error("Attempt to #{action_name} invalid id #{params[:id]}")
       flash[:error] = "Invalid ID specified for #{action_name} action."
       redirect_to :action => 'index'
    end
  end
end
