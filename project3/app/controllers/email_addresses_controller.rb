class EmailAddressesController < ApplicationController
  
  before_filter :get_engineer
  
  #
  # Adds Email Address to Engineer
  #
  def create
     #puts "EmailAddresses.add_email_address"
     @email_address = EmailAddress.new(params[:email_address])
     if @email_address.valid?
        @engineer.email_addresses << @email_address
        flash.now[:error] = ""
     else        
        flash.now[:error] = "Failed to add email address.  Check your data syntax."
     end
     render :partial => 'engineers/email_address_list', :object => @engineer  
  end
  #
  #  Removes Email Address from Engineer
  #
  def destroy
     #puts "EmailAddresses.remove_email_address"
     @email_address = EmailAddress.find(params[:email_address_id])
     @email_address.destroy
     render :partial => 'engineers/email_address_list', :object => @engineer  
   end
protected
  def get_engineer
     @engineer = Engineer.find(params[:engineer_id])  
  end
end
