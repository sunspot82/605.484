class ResourcesController < ApplicationController

  around_filter :record_not_found
  
  def index
     if params[:engineer_id]
       @resources = Resource.paginate :per_page => 5, :page => params[:page], :conditions => ['engineer_id = ?',params[:engineer_id]], :order => :engineer_id
     else
        @resources = Resource.paginate :per_page => 5, :page => params[:page], :order => :engineer_id
     end

     respond_to do |format|
        format.html
        format.xml { render :xml => @resources }
     end
  end
  
  def show
     @resource = Resource.find(params[:id])
     
     respond_to do |format|
        format.html
        format.xml { render :xml => @resource }        
     end
  end
  
  def new
     @resource = Resource.new
     
     respond_to do |format|
        format.html
        format.xml { render :xml => @resource }
     end
  end
  
  def edit
     @resource = Resource.find(params[:id])
  end
  
  def create
     @resource = Resource.new(params[:resource])
     logger.info("role: " + @resource.role)
     logger.info("url: " + @resource.f.url)
     respond_to do |format|
        if @resource.save
           flash[:notice] = 'Resource was successfully created'  
           format.html { redirect_to(@resource) }
           format.xml { render :xml => @resource, :status => :created, :location => @resource }
        else
           format.html { render :action => "new" }
           format.xml { render :xml => @resource.errors, :status => :unprocessable_entity }
        end
     end
  end
  
  def update
     @resource = Resource.find(params[:id])
     
     respond_to do |format|
        if @resource.update_attributes(params[:resource])
           flash[:notice] = 'Resource was successfully updated.'
           format.html { redirect_to(@resource) }
           format.xml { head :ok }
        else
           format.html { render :action => "edit" }
           format.xml { render :xml => @resource.errors, :status => :unprocessable_entity }
        end
     end
  end
  
  def destroy
     @resource = Resource.find(params[:id])
     @resource.destroy
     
     respond_to do |format|
        format.html { redirect_to(resources_url) }
        format.xml { head :ok }
     end
  end
end
