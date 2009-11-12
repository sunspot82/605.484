class EngineersController < ApplicationController
  before_filter :get_tags
  around_filter :record_not_found
  
  # GET /engineers/tag
  def tag
     @engineers = Engineer.find_tagged_with(params[:id]).paginate :per_page => 5, :page => params[:page], :order => 'name'    
     flash[:notice] = "Items tagged with '#{params[:id]}'"
     render(:action => :index)
  end
  
  # GET /engineers
  # GET /engineers.xml
  def index
    #@engineers = Engineer.all
    @engineers = Engineer.paginate :per_page => 5, :page => params[:page], :order => 'name'
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @engineers }
    end
  end

# GET /engineers/1
  # GET /engineers/1.xml
  def show   
       @engineer = Engineer.find(params[:id])
       respond_to do |format|
          format.html # show.html.erb
          format.xml  { render :xml => @engineer }
       end    
  end

  # GET /engineers/new
  # GET /engineers/new.xml
  def new
    @engineer = Engineer.new    
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @engineer }
    end
  end

  # GET /engineers/1/edit
  def edit
       @engineer = Engineer.find(params[:id])        
  end

  # POST /engineers
  # POST /engineers.xml
  def create
    @engineer = Engineer.new(params[:engineer])        
    respond_to do |format|
      if @engineer.save
        flash[:notice] = 'Engineer was successfully created.'
        format.html { redirect_to(@engineer) }
        format.xml  { render :xml => @engineer, :status => :created, :location => @engineer }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @engineer.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /engineers/1
  # PUT /engineers/1.xml
  def update    
       @engineer = Engineer.find(params[:id])

       respond_to do |format|
          if @engineer.update_attributes(params[:engineer])
             flash[:notice] = 'Engineer was successfully updated.'
             if params[:resource]
                logger.info("Creating resource #{params[:resource]}")
                @resource = Resource.new(params[:resource])
                @resource.engineer = @engineer
                @resource.save!
                flash[:notice] = flash[:notice] + "<br />Resource #{@resource.role} successfully saved."
             end             
             format.html { redirect_to(@engineer) }
             format.xml  { head :ok }
          else
             format.html { render :action => "edit" }
             format.xml  { render :xml => @engineer.errors, :status => :unprocessable_entity }
          end
       end    
  end

  # DELETE /engineers/1
  # DELETE /engineers/1.xml
  def destroy
    @engineer = Engineer.find(params[:id])
    @engineer.destroy

    respond_to do |format|
      format.html { redirect_to(engineers_url) }
      format.xml  { head :ok }
    end    
  end
  
  # Deletes an Engineer's Resource
  def destroy_resource
     @resource = Engineer.resources.find(params[:id])
     @resource.destroy
     flash[:notice] = "Resource '#{@resource.role}' successfully removed."     
     redirect_to(:back)
   end
   
  private
  
  def get_tags
    @tags = Engineer.tag_counts
  end  
end
