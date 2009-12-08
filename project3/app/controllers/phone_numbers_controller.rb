class PhoneNumbersController < ApplicationController
  
  before_filter :get_engineer  
  #
  #  Adds Phone Number to Engineer
  #  
  def create     
     @phone_number = PhoneNumber.new(params[:phone_number])
     if @phone_number.valid?
        @engineer.phone_numbers << @phone_number
        flash.now[:error] = ""
     else
        flash.now[:error] = "Failed to add phone number.  Check your data syntax."
     end
     render :partial => 'engineers/phone_number_list', :object => @engineer  
  end
  #
  #  Removes Phone Number from Engineer
  #
  def destroy
     @phone_number = PhoneNumber.find(params[:phone_number_id])
     @phone_number.destroy
     render :partial => 'engineers/phone_number_list', :object => @engineer  
   end
protected
  def get_engineer
     @engineer = Engineer.find(params[:engineer_id])  
  end
end
