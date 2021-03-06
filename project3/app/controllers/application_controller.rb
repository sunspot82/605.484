# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details
   
  around_filter :record_not_found
  
  auto_complete_for :name, :fname
  auto_complete_for :name, :lname
  
  auto_complete_for :project, :name
  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password
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
